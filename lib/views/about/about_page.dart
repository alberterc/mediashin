import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:mediashin/widgets/hyperlink.dart';
import 'package:mediashin/widgets/window_title_bar.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  Map<String, String> appInfo = {'version': 'N/A'};

  @override
  void initState() {
    super.initState();
    _getAppInfo();
  }

  Future _getAppInfo() async {
    PackageInfo res = await PackageInfo.fromPlatform();
    setState(() {
      appInfo['version'] = res.version;
    });
  }

  TableRow _buildTableRow(Widget label, Widget value) {
    return TableRow(children: [label, const Center(child: Text(':')), value]);
  }

  @override
  Widget build(BuildContext context) {
    SizedBox spacer = const SizedBox(height: 53);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const WindowTitleBar(
          backButton: true,
          title: Text('Mediashin'),
        ),
        Text('About', style: FluentTheme.of(context).typography.title),
        spacer,
        Text(
          'Mediashin',
          style: FluentTheme.of(context).typography.subtitle,
        ),
        const SizedBox(height: 16),
        const Image(
          image: AssetImage('assets/images/mediashin-logo.png'),
          width: 100,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 400,
          child: Table(
            columnWidths: const {
              0: IntrinsicColumnWidth(),
              1: FixedColumnWidth(20),
              2: FlexColumnWidth()
            },
            children: [
              _buildTableRow(
                  const Text('Version'), Text('v${appInfo['version']!}')),
              _buildTableRow(
                  const Text('Author'),
                  const Hyperlink(
                      text: 'alberterc', url: 'https://github.com/alberterc')),
              _buildTableRow(
                  const Text('Repository'),
                  const Hyperlink(
                    text: 'github.com/alberterc/mediashin',
                    url: 'https://github.com/alberterc/mediashin',
                  )),
              _buildTableRow(
                  const Text('License'),
                  const Hyperlink(
                    text: 'BSD-3-Clause',
                    url:
                        'https://raw.githubusercontent.com/alberterc/mediashin/refs/heads/main/LICENSE',
                  )),
            ],
          ),
        ),
        const SizedBox(height: 16),
        HyperlinkButton(
          onPressed: () => GoRouter.of(context).push('/licenses'),
          style: FluentTheme.of(context)
              .buttonTheme
              .hyperlinkButtonStyle
              ?.copyWith(
                padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0)),
              ),
          child: const Text('View Licenses'),
        )
      ],
    );
  }
}
