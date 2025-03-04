import 'package:fluent_ui/fluent_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class Hyperlink extends StatelessWidget {
  final String text;
  final String url;
  final WidgetStateProperty<TextStyle>? textStyle;
  const Hyperlink({super.key, required this.text, required this.url, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return HyperlinkButton(
      style: FluentTheme.of(context).buttonTheme.hyperlinkButtonStyle?.copyWith(
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        textStyle: textStyle ?? WidgetStateProperty.resolveWith((states) {
          if (states.isHovered) {
            return const TextStyle(decoration: TextDecoration.underline);
          } else {
            return const TextStyle(decoration: TextDecoration.none);
          }
        })
      ),
      onPressed: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      child: Align(alignment: Alignment.topLeft, child: Text(text)),
    );
  }
}