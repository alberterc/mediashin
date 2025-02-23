import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:mediashin/collections/ffmpeg.dart';
import 'package:mediashin/collections/ffprobe.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

import '../components/window_title_bar.dart';
import '../collections/statics.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener {

  @override
  initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  Future<Map<String, bool>> _checkDependencies() async {
    final ffmpeg = await Ffmpeg().isInstalled();
    final ffprobe = await Ffprobe().isInstalled();
    return {
      'ffmpeg': ffmpeg,
      'ffprobe': ffprobe
    };
  }

  @override
  Widget build(BuildContext context) {
    SizedBox spacer = const SizedBox(height: 53);
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const WindowTitleBar(),
            Text(
              'Mediashin',
              style: FluentTheme.of(context).typography.title
            ),
            // spacer,
            // SizedBox(
            //   width: 320,
            //   child: AutoSuggestBox(
            //     placeholder: 'Find a function',
            //     trailingIcon: const Icon(FluentIcons.search),
            //     items: pages.map((page) {
            //       return AutoSuggestBoxItem (
            //         label: page.name,
            //         value: page.id,
            //         onFocusChange: (focused) {
            //           if (focused) {}
            //         },
            //       );
            //     }).toList(),
            //   ),
            // ),
            spacer,
            FutureBuilder(
              future: _checkDependencies(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ProgressRing();
                }
                else {
                  final ffmpeg = snapshot.data?['ffmpeg'] ?? false;
                  final ffprobe = snapshot.data?['ffprobe'] ?? false;
                  if (ffmpeg && ffprobe) {
                    return SingleChildScrollView(
                      child: _buildBody(context),
                    );
                  }
                  else if (!ffmpeg && !ffprobe) {
                    return Column(
                      children: [
                        Text(
                          'Ffprobe and Ffmpeg are not found/installed.',
                          style: FluentTheme.of(context).typography.bodyStrong,
                        ),
                        const SizedBox(height: 24.0),
                        Button(
                          child: const Text('Click here to download from https://ffmpeg.org/download.html'),
                          onPressed: () => launchUrl(
                            Uri.parse('https://ffmpeg.org/download.html'),
                            mode: LaunchMode.externalApplication
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'then put them in your system\'s PATH environment and restart Mediashin.',
                          style: FluentTheme.of(context).typography.body,
                        ),
                      ],
                    );
                  }
                  if (!ffprobe) {
                    return Column(
                      children: [
                        Text(
                          'Ffprobe is not found/installed.',
                          style: FluentTheme.of(context).typography.bodyStrong,
                        ),
                        const SizedBox(height: 24.0),
                        Button(
                          child: const Text('Click here to download from https://ffmpeg.org/download.html'),
                          onPressed: () => launchUrl(
                            Uri.parse('https://ffmpeg.org/download.html'),
                            mode: LaunchMode.externalApplication
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'then put it in your system\'s PATH environment and restart Mediashin.',
                          style: FluentTheme.of(context).typography.body,
                        ),
                      ],
                    );
                  }
                  else if (!ffmpeg) {
                    return Column(
                      children: [
                        Text(
                          'Ffmpeg is not found/installed.',
                          style: FluentTheme.of(context).typography.bodyStrong,
                        ),
                        const SizedBox(height: 24.0),
                        Button(
                          child: const Text('Click here to download from https://ffmpeg.org/download.html'),
                          onPressed: () => launchUrl(
                            Uri.parse('https://ffmpeg.org/download.html'),
                            mode: LaunchMode.externalApplication
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'then put it in your system\'s PATH environment and restart Mediashin.',
                          style: FluentTheme.of(context).typography.body,
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }
              }
            ),
          ],
        ),
        Positioned(
          bottom: 7,
          right: 7,
          child: HyperlinkButton(
            onPressed: () => context.push('/about'),
            style: FluentTheme.of(context).buttonTheme.hyperlinkButtonStyle?.copyWith(
              padding: const WidgetStatePropertyAll(EdgeInsets.all(8.0)),
              textStyle: WidgetStatePropertyAll(FluentTheme.of(context).typography.caption)
            ),
            child: const Text('About'),
          )
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 32.0),
      child: Column(
        children: [
          SizedBox(
            width: 825,
            child: GridView(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 267 / 100
              ),
              children: pages.map((page) {
                return _buildCard(page.name, page.desc, context);
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCard(String title, String desc, BuildContext context) {
    return Button(
    style: const ButtonStyle(
      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0)),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7.0)))),
    ),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: FluentTheme.of(context).typography.bodyStrong, textAlign: TextAlign.left),
          const SizedBox(height: 4.0),
          Text(desc, style: FluentTheme.of(context).typography.body, textAlign: TextAlign.left)
        ],
      ),
    ),
    onPressed: () => GoRouter.of(context).push('/${title.toLowerCase()}'),
  );
  }
}