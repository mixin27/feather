import 'package:feather/src/blocs/application_bloc.dart';
import 'package:feather/src/models/internal/navigation_route.dart';
import 'package:feather/src/resources/config/application_config.dart';
import 'package:feather/src/resources/application_localization_delegate.dart';
import 'package:feather/src/resources/location_manager.dart';
import 'package:feather/src/resources/repository/local/application_local_repository.dart';
import 'package:feather/src/resources/repository/local/weather_local_repository.dart';
import 'package:feather/src/resources/repository/remote/weather_remote_repository.dart';
import 'package:feather/src/ui/about/about_screen_bloc.dart';
import 'package:feather/src/ui/main/main_screen.dart';
import 'package:feather/src/ui/main/main_screen_bloc.dart';
import 'package:feather/src/ui/navigation/navigation.dart';
import 'package:feather/src/ui/navigation/navigation_bloc.dart';
import 'package:feather/src/ui/navigation/navigation_state.dart';
import 'package:feather/src/ui/about/about_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Navigation _navigation = Navigation();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  final LocationManager _locationManager = LocationManager();
  final WeatherLocalRepository _weatherLocalRepository =
      WeatherLocalRepository();
  final WeatherRemoteRepository _weatherRemoteRepository =
      WeatherRemoteRepository();
  final ApplicationLocalRepository _applicationLocalRepository =
      ApplicationLocalRepository();

  MyApp() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _navigation.defineRoutes();
    _configureLogger();
    applicationBloc.loadSavedUnit();
    applicationBloc.loadSavedRefreshTime();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(
          create: (context) => NavigationBloc(_navigation, _navigatorKey),
        ),
        BlocProvider<MainScreenBloc>(
          create: (context) => MainScreenBloc(
              _locationManager,
              _weatherLocalRepository,
              _weatherRemoteRepository,
              _applicationLocalRepository),
        ),
        BlocProvider<AboutScreenBloc>(create: (context) => AboutScreenBloc())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: _navigatorKey,
        theme: _configureThemeData(),
        localizationsDelegates: [
          const ApplicationLocalizationDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale("en"),
          const Locale("pl"),
        ],
        onGenerateRoute: _navigation.router.generator,
      ),
    );
  }

  void _configureLogger() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      if (ApplicationConfig.isDebug) {
        print(
            '[${rec.level.name}][${rec.time}][${rec.loggerName}]: ${rec.message}');
      }
    });
  }

  ThemeData _configureThemeData() {
    return ThemeData(
      textTheme: TextTheme(
        headline5: TextStyle(fontSize: 60.0, color: Colors.white),
        headline6: TextStyle(fontSize: 35, color: Colors.white),
        subtitle2: TextStyle(fontSize: 20, color: Colors.white),
        bodyText2: TextStyle(fontSize: 15, color: Colors.white),
        bodyText1: TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }
}
