import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:mediashin/collections/colors.dart';
import 'package:mediashin/collections/ffprobe.dart';
import 'package:mediashin/models/video_details.dart';

import '../components/window_title_bar.dart';

VideoDetails videoDetails = VideoDetails();
const _kSimpleDetailContainerWidth = 600.0;
final ffprobe = Ffprobe();

class AnalyzePage extends StatefulWidget {
  const AnalyzePage({super.key});

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  bool _isFilePicked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WindowTitleBar(
          backButton: true,
          title: 'Mediashin',
        ),
        SizedBox(
          // TODO: height and width needs to be adjusted everytime the window size changes
          height: appWindow.size.height - appWindow.titleBarHeight - 15,
          width: appWindow.size.width,
          child: _buildBody(context)
        )
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
              child: _isFilePicked
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
                        child: SimpleDetails(),
                      ),
                      divider,
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                        child: _hyperlinkButton(
                          text: 'More Details',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const MoreDetails(),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      _hyperlinkButton(
                        text: 'Change File',
                        onPressed: _loadVideoFile
                      )
                    ],
                  )
                : Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 4.0, bottom: 12.0),
                      child: Text('No video file selected'),
                    ),
                    divider,
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                      child: _hyperlinkButton(
                        text: 'Select File',
                        onPressed: _loadVideoFile
                      ),
                    )
                  ],
                )
            )
          ],
        )
      ),
    );
  }

  Widget _hyperlinkButton({VoidCallback? onPressed, String? text}) {
    return HyperlinkButton(
      onPressed: onPressed ?? () {},
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(FluentTheme.of(context).typography.body),
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 8.0)),
      ),
      child: SizedBox(
        width: _kSimpleDetailContainerWidth - 20,
        child: Text(
          text ?? 'Button',
          style: FluentTheme.of(context).typography.body!.copyWith(color: AppColors.accentText)
        ),
      ),
    );
  }

  Future _loadVideoFile() async {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
      withData: false,
      withReadStream: false
    );

    if (filePickerResult != null) {
      var videoDetailsStr = await ffprobe.run(
        printFormat: 'json',
        filePath: filePickerResult.files.single.path!,
        entries: [
          // TODO: nb_streams, duration, and bit_rate may not be needed
          'format=filename,nb_streams,format_name,format_long_name,duration,size,bit_rate',
          'format_tags=creation_time',
          'stream=index,codec_name,codec_long_name,codec_type,codec_tag_string,width,height,color_range,display_aspect_ratio,r_frame_rate,bit_rate,sample_rate,channels,duration',
          'stream_tags=creation_time'
        ]
      );
      videoDetails = VideoDetails.fromJson(jsonDecode(videoDetailsStr));
      setState(() {
        _isFilePicked = true;
      });
    }
  }
}

class SimpleDetails extends StatelessWidget {
  SimpleDetails({super.key});

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
            Text('Filename', style: FluentTheme.of(context).typography.bodyStrong, maxLines: 3, overflow: TextOverflow.ellipsis,),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(videoDetails.format!.filename!, style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text('Duration', style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(videoDetails.format!.duration!, style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text('Format', style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(videoDetails.format!.formatName!, style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text('Codec', style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(videoDetails.streams![0].codecName!, style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text('Resolution', style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text('${videoDetails.streams![0].width!}x${videoDetails.streams![0].height!}', style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text('Bit Rate', style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(videoDetails.format!.bitRate!, style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text('Size', style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(videoDetails.format!.size!, style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text('Streams', style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(videoDetails.format!.nbStreams!.toString(), style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text('Created Time', style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(videoDetails.format!.tags!.creationTime != null ? videoDetails.format!.tags!.creationTime!.toString() : 'N/A', style: FluentTheme.of(context).typography.body)
          ]
        ),
      ]
    );
  }
}

class MoreDetails extends StatelessWidget {
  const MoreDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      content: Acrylic(
        luminosityAlpha: 0.8,
        blurAmount: 35,
        tintAlpha: 0,
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Test'),
        )
      ),
      style: const ContentDialogThemeData(
        decoration: BoxDecoration()
      ),
    );
  }
}