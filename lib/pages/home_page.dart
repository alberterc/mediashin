import 'package:fluent_ui/fluent_ui.dart';

import '../widgets/title_bar.dart';
import 'pages.dart';

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

  return Center(
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
        // GridView.builder(
        //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        //   itemBuilder: (_, index) {
        //     var page = pages[index];
        //     return Card(
        //       backgroundColor: Colors.white.withOpacity(0.0513),
        //       child: Column(
        //         children: [
        //           Text(page.name),
        //           Text(page.desc)
        //         ],
        //       ),
        //     );
        //   },
        // )
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: pages.map((page) {
            return SizedBox(
              width: 267,
              height: 100,
              child: Card(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                borderRadius: BorderRadius.circular(7.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(page.name, style: FluentTheme.of(context).typography.bodyStrong),
                    const SizedBox(height: 4.0),
                    Text(page.desc, style: FluentTheme.of(context).typography.body)
                  ],
                ),
              ),
            );
          }).toList(),
        )
      ],
    ),
  );
}