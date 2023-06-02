import 'package:feather/src/resources/config/assets.dart';
import 'package:feather/src/ui/about/bloc/about_screen_bloc.dart';
import 'package:feather/src/ui/about/bloc/about_screen_state.dart';
import 'package:feather/src/ui/widget/animated_gradient.dart';
import 'package:feather/src/ui/widget/transparent_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  final List<Color> startGradientColors;

  const AboutScreen({Key? key, this.startGradientColors = const []})
      : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
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
          AnimatedGradientWidget(
            duration: const Duration(seconds: 3),
            startGradientColors: widget.startGradientColors,
          ),
          SafeArea(
            child: Stack(
              children: [
                BlocBuilder<AboutScreenBloc, AboutScreenState>(
                  bloc: _aboutScreenBloc,
                  builder: (context, state) {
                    return Container(
                      key: const Key("weather_main_screen_container"),
                      child: _buildMainWidget(context),
                    );
                  },
                ),
                const TransparentAppBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainWidget(BuildContext context) {
    final applicationLocalization = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLogoWidget(),
          Text(
            "feather",
            key: const Key("about_screen_app_name"),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          _buildVersionWidget(),
          const SizedBox(height: 20),
          Text(
            "${applicationLocalization.contributors}:",
            key: const Key("about_screen_contributors"),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          const Text("Jakub Homlala (jhomlala)"),
          const SizedBox(height: 20),
          Text(
            "${applicationLocalization.credits}:",
            key: const Key("about_screen_credits"),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          Text(applicationLocalization.weather_data),
          const SizedBox(height: 2),
          Text(applicationLocalization.icon_data)
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
      ),
    );
  }

  Widget _buildVersionWidget() {
    return FutureBuilder<String>(
      future: _getVersionAndBuildNumber(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data!,
            key: const Key("about_screen_app_version_and_build"),
            style: Theme.of(context).textTheme.titleSmall,
          );
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
    final uri = Uri.parse('https://github.com/jhomlala/feather');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
