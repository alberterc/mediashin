import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:mediashin/widgets/pane_item_body.dart';
import 'package:mediashin/widgets/window_title_bar.dart';

class LicensePage extends StatefulWidget {
  const LicensePage({super.key});

  @override
  State<LicensePage> createState() => _LicensePageState();
}

class _LicensePageState extends State<LicensePage> {
  final Map<String, _PackageEntry> packageEntries = {};
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getPackagesData();
  }

  Future _getPackagesData() async {
    await for (final licenseEntry in LicenseRegistry.licenses) {
      for (final package in licenseEntry.packages) {
        packageEntries.putIfAbsent(
            package, () => _PackageEntry(occurrences: []));
        packageEntries[package]!
            .occurrences
            .add(licenseEntry.paragraphs.toList());
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizedBox spacer = const SizedBox(height: 33);
    List<String> packageNames = packageEntries.keys.toList()..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const WindowTitleBar(
          backButton: true,
          title: Text('Mediashin'),
        ),
        Text('Licenses', style: FluentTheme.of(context).typography.title),
        spacer,
        Expanded(
          child: NavigationPaneTheme(
            data: NavigationPaneThemeData(
                backgroundColor: FluentTheme.of(context).menuColor),
            child: NavigationView(
              pane: NavigationPane(
                header: const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text('Packages'),
                ),
                selected: selectedIndex,
                displayMode: PaneDisplayMode.open,
                onChanged: (index) => setState(() {
                  selectedIndex = index;
                }),
                items: packageNames
                    .asMap()
                    .entries
                    .map<NavigationPaneItem>((entry) {
                  final packageName = entry.value;
                  final packageEntry = packageEntries[packageName]!;
                  return PaneItem(
                      icon: const Icon(FluentIcons.caret_solid_alt,
                          size: 0, color: Colors.transparent),
                      title: Text(packageName,
                          style: FluentTheme.of(context).typography.bodyStrong),
                      body: PaneItemBody(
                        header: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(packageName,
                                style: FluentTheme.of(context)
                                    .typography
                                    .bodyStrong
                                    ?.copyWith(fontSize: 16)),
                            Text(
                                '${packageEntry.occurrences.length} license${packageEntry.occurrences.length > 1 ? 's' : ''}',
                                style: FluentTheme.of(context)
                                    .typography
                                    .body
                                    ?.copyWith(
                                        color: const Color.fromARGB(
                                            255, 133, 133, 133)))
                          ],
                        ),
                        content: _LicenseView(packageEntry: packageEntry),
                      ));
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PackageEntry {
  final List<List<LicenseParagraph>> occurrences;

  _PackageEntry({required this.occurrences});
}

class _LicenseView extends StatelessWidget {
  final _PackageEntry packageEntry;

  const _LicenseView({required this.packageEntry});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: packageEntry.occurrences.expand<Widget>((occurrence) sync* {
          for (final paragraph in occurrence) {
            yield Padding(
                padding: EdgeInsetsDirectional.only(
                  top: 8.0,
                  start: paragraph.indent == LicenseParagraph.centeredIndent
                      ? 0.0
                      : 16.0 * paragraph.indent,
                ),
                child: Text(
                  paragraph.text,
                  style: paragraph.indent == LicenseParagraph.centeredIndent
                      ? FluentTheme.of(context).typography.bodyStrong
                      : FluentTheme.of(context).typography.body,
                  textAlign: paragraph.indent == LicenseParagraph.centeredIndent
                      ? TextAlign.center
                      : TextAlign.start,
                ));
          }

          if (packageEntry.occurrences.indexOf(occurrence) <
              packageEntry.occurrences.length - 1) {
            yield const Padding(
              padding: EdgeInsets.all(16.0),
              child: Divider(
                style: DividerThemeData(
                    decoration: BoxDecoration(color: Colors.white)),
              ),
            );
          }
        }).toList());
  }
}
