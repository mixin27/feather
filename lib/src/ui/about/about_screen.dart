import 'package:feather/src/resources/application_localization.dart';
import 'package:feather/src/resources/config/assets.dart';
import 'package:feather/src/ui/about/about_screen_bloc.dart';
import 'package:feather/src/ui/about/about_screen_state.dart';
import 'package:feather/src/ui/widget/animated_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late AboutScreenBloc _aboutScreenBloc;

  @override
  void initState() {
    _aboutScreenBloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          const AnimatedGradientWidget(
            duration: Duration(seconds: 5),
          ),
          BlocBuilder<AboutScreenBloc, AboutScreenState>(
            bloc: _aboutScreenBloc,
            builder: (context, state) {
              return Container(
                key: const Key("weather_main_screen_container"),
                child: _buildMainWidget(context),
              );
            },
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              backgroundColor: Colors.transparent, //No more green
              elevation: 0.0, //Shadow gone
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainWidget(BuildContext context) {
    final applicationLocalization = ApplicationLocalization.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLogoWidget(),
          Text("feather",
              key: const Key("about_screen_app_name"),
              style: Theme.of(context).textTheme.headline6),
          _buildVersionWidget(),
          const SizedBox(height: 20),
          Text("${applicationLocalization.getText("contributors")}:",
              key: const Key("about_screen_contributors"),
              style: Theme.of(context).textTheme.subtitle2),
          const SizedBox(height: 10),
          const Text("Jakub Homlala (jhomlala)"),
          const SizedBox(height: 20),
          Text("${applicationLocalization.getText("credits")}:",
              key: const Key("about_screen_credits"),
              style: Theme.of(context).textTheme.subtitle2),
          const SizedBox(height: 10),
          Text(applicationLocalization.getText("weather_data")!),
          const SizedBox(height: 2),
          Text(applicationLocalization.getText("icon_data")!)
        ],
      ),
    );
  }

  Widget _buildLogoWidget() {
    return Material(
        type: MaterialType.circle,
        clipBehavior: Clip.hardEdge,
        color: Colors.white10,
        child: InkWell(
          onTap: () => _onLogoClicked(),
          child: Image.asset(
            Assets.iconLogo,
            key: const Key("about_screen_logo"),
            width: 256,
            height: 256,
          ),
        ));
  }

  Widget _buildVersionWidget() {
    return FutureBuilder<String>(
      future: _getVersionAndBuildNumber(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!,
              key: const Key("about_screen_app_version_and_build"),
              style: Theme.of(context).textTheme.subtitle2);
        } else {
          return Container(
            key: const Key("about_screen_app_version_and_build"),
          );
        }
      },
    );
  }

  Future<String> _getVersionAndBuildNumber() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return "${packageInfo.version} (${packageInfo.buildNumber})";
  }

  void _onLogoClicked() async {
    const url = 'https://github.com/jhomlala/feather';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
