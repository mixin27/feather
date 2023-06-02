import 'package:feather/src/data/model/internal/forecast_navigation_params.dart';
import 'package:feather/src/data/model/internal/navigation_route.dart';
import 'package:feather/src/data/model/internal/settings_navigation_params.dart';
import 'package:feather/src/ui/navigation/bloc/navigation_event.dart';
import 'package:feather/src/ui/navigation/bloc/navigation_state.dart';
import 'package:feather/src/ui/navigation/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final NavigationProvider _navigationProvider;
  final GlobalKey<NavigatorState> _navigatorKey;

  NavigationBloc(
    this._navigationProvider,
    this._navigatorKey,
  ) : super(const NavigationState(NavigationRoute.mainScreen)) {
    on<MainScreenNavigationEvent>((event, emit) {
      _navigateToPath("/");
      emit(const NavigationState(NavigationRoute.mainScreen));
    });

    on<ForecastScreenNavigationEvent>((event, emit) {
      _navigateToPath(
        "/forecast",
        routeSettings: RouteSettings(
          arguments: ForecastNavigationParams(event.holder),
        ),
      );
      emit(const NavigationState(NavigationRoute.forecastScreen));
    });

    on<AboutScreenNavigationEvent>((event, emit) {
      _navigateToPath(
        "/about",
        routeSettings: RouteSettings(
          arguments: SettingsNavigationParams(event.startGradientColors),
        ),
      );
      emit(
        const NavigationState(
          NavigationRoute.aboutScreen,
        ),
      );
    });

    on<SettingsScreenNavigationEvent>((event, emit) {
      _navigateToPath(
        "/settings",
        routeSettings: RouteSettings(
          arguments: SettingsNavigationParams(event.startGradientColors),
        ),
      );
      emit(const NavigationState(NavigationRoute.settingsScreen));
    });
  }

  void _navigateToPath(String path, {RouteSettings? routeSettings}) {
    _navigationProvider.navigateToPath(
      path,
      _navigatorKey,
      routeSettings: routeSettings,
    );
  }
}
