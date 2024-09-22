import 'package:fluent_ui/fluent_ui.dart';
import 'package:mediashin/collections/colors.dart';
import 'package:mediashin/models/video_details.dart';

import '../components/window_title_bar.dart';

const _kSimpleDetailContainerWidth = 400.0;

class AnalyzePage extends StatelessWidget {
  const AnalyzePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WindowTitleBar(
          backButton: true,
          title: 'Mediashin',
        ),
        _buildBody(context)
      ],
    );
  }
  
  Widget _buildBody(BuildContext context) {
    SizedBox spacer = const SizedBox(height: 53);
    Container divider = Container(
      height: 1,
      color: const Color(0xFF191927),
    );
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 32.0),
      child: Center(
        child: Column(
          children: [
            Text(
              'Analyze',
              style: FluentTheme.of(context).typography.title
            ),
            spacer,
            Container(
              padding: const EdgeInsets.all(8.0),
              width: _kSimpleDetailContainerWidth,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(7.0)
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4.0, bottom: 12.0),
                    child: SimpleDetails(),
                  ),
                  divider,
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                    child: DetailedDetailsButton(),
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}

class SimpleDetails extends StatefulWidget {
  const SimpleDetails({super.key});

  @override
  State<SimpleDetails> createState() => _SimpleDetailsState();
}

class _SimpleDetailsState extends State<SimpleDetails> {
  final TableRow rowSpacer = TableRow(
    children: List.generate(3, (_) => const SizedBox(height: 8.0))
  );

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(.32),
        1: FlexColumnWidth(.03),
        2: FlexColumnWidth(1)
      },
      children: [
        TableRow(
          children: [
            Text(simpleVideoDetails[0].name, style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(simpleVideoDetails[0].desc, style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text(simpleVideoDetails[1].name, style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(simpleVideoDetails[1].desc, style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text(simpleVideoDetails[2].name, style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(simpleVideoDetails[2].desc, style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text(simpleVideoDetails[3].name, style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(simpleVideoDetails[3].desc, style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text(simpleVideoDetails[4].name, style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(simpleVideoDetails[4].desc, style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text(simpleVideoDetails[5].name, style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(simpleVideoDetails[5].desc, style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text(simpleVideoDetails[6].name, style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(simpleVideoDetails[6].desc, style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text(simpleVideoDetails[7].name, style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(simpleVideoDetails[7].desc, style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text(simpleVideoDetails[8].name, style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(simpleVideoDetails[8].desc, style: FluentTheme.of(context).typography.body)
          ]
        ),
      ]
    );
  }
}

class DetailedDetailsButton extends StatelessWidget {
  const DetailedDetailsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return HyperlinkButton(
      onPressed: () {},
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(FluentTheme.of(context).typography.body),
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 8.0)),
      ),
      child: SizedBox(
        width: _kSimpleDetailContainerWidth - 20,
        child: Text(
          'More Details',
          style: FluentTheme.of(context).typography.body!.copyWith(color: AppColors.accentText)
        ),
      ),
    );
  }
}