import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

import '../components/window_title_bar.dart';
import '../collections/pages.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WindowTitleBar(),
        _buildBody(context)
      ],
    );
  }
}

Widget _buildBody(BuildContext context) {
  SizedBox spacer = const SizedBox(height: 53);
  return Padding(
    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 32.0),
    child: Center(
      child: Column(
        children: [
          Text(
            'Mediashin',
            style: FluentTheme.of(context).typography.title
          ),
          spacer,
          SizedBox(
            width: 320,
            child: AutoSuggestBox(
              placeholder: 'Find a function',
              trailingIcon: const Icon(FluentIcons.search),
              items: pages.map((page) {
                return AutoSuggestBoxItem (
                  label: page.name,
                  value: page.id,
                  onFocusChange: (focused) {
                    if (focused) {}
                  },
                );
              }).toList(),
            ),
          ),
          spacer,
          SizedBox(
            width: 825,
            // need to change into stateful so height can change when window is resized
            height: appWindow.size.height - appWindow.size.height * 46 / 100,
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
    ),
  );
}

Widget _buildCard(String title, String desc, BuildContext context) => Button(
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