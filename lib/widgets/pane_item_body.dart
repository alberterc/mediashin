import 'package:fluent_ui/fluent_ui.dart';

class PaneItemBody extends StatelessWidget {
  final Widget header;
  final Widget content;

  const PaneItemBody({super.key, required this.header, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(child: content),
          )
        ],
      ),
    );
  }
}
