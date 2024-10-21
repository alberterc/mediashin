import 'dart:convert';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:mediashin/collections/colors.dart';
import 'package:mediashin/collections/ffprobe.dart';
import 'package:mediashin/collections/select_video_file.dart';
import 'package:mediashin/models/video_details.dart';
import 'package:mime/mime.dart';
import 'package:window_manager/window_manager.dart';

import '../components/window_title_bar.dart';

VideoDetails _videoDetails = VideoDetails();

class AnalyzePage extends StatefulWidget {
  const AnalyzePage({super.key});

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> with WindowListener {
  bool _isFilePicked = false;
  bool _draggingFile = false;
  static const _kSimpleDetailContainerWidth = 500.0;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
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
        Text(
          'Analyze',
          style: FluentTheme.of(context).typography.title
        ),
        spacer,
        Expanded(
          child: SingleChildScrollView(
            child: DropTarget(
              onDragDone: (details) {
                if (details.files.length == 1) {
                  _analyzeVideoFile(details.files.first.path);
                }
              },
              onDragEntered: (_) {
                setState(() {
                  _draggingFile = true;
                });
              },
              onDragExited: (_) {
                setState(() {
                  _draggingFile = false;
                });
              },
              child: _buildBody(context)
            ),
          ),
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    Container divider = Container(
      height: 1,
      color: const Color(0xFF191927),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 32.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: _kSimpleDetailContainerWidth,
        decoration: BoxDecoration(
          color: _draggingFile ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.05),
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
                  text: 'Change Video File',
                  onPressed: () {
                    selectVideoFile().then((file) {
                      if (file != '') {
                        _analyzeVideoFile(file);
                      }
                    });
                  }
                ),
                Text(
                  'or drop a video file here',
                  style: FluentTheme.of(context).typography.caption!.copyWith(color: Colors.white.withOpacity(0.5)),
                )
              ],
            )
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 4.0, bottom: 12.0),
                  child: Text('No video file selected.'),
                ),
                divider,
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: _hyperlinkButton(
                    text: 'Select a Video File',
                    onPressed: () {
                      selectVideoFile().then((file) {
                        if (file != '') {
                          _analyzeVideoFile(file);
                        }
                      });
                    }
                  ),
                ),
                Text(
                  'or drop a video file here',
                  style: FluentTheme.of(context).typography.caption!.copyWith(color: Colors.white.withOpacity(0.5)),
                )
              ],
            )
      ),
    );
  }

  Widget _hyperlinkButton({VoidCallback? onPressed, String? text}) {
    return HyperlinkButton(
      onPressed: onPressed ?? () {},
      child: SizedBox(
        width: _kSimpleDetailContainerWidth - 20,
        child: Text(
          text ?? 'Button',
          style: FluentTheme.of(context).typography.body!.copyWith(color: AppColors.accentText)
        ),
      ),
    );
  }

  void _analyzeVideoFile(String filePath) async {
    if (lookupMimeType(filePath)!.startsWith('video/')) {
      final ffprobe = Ffprobe();
      var videoDetailsStr = await ffprobe.run(
        printFormat: 'json',
        filePath: filePath,
        entries: [
          // TODO: nb_streams, duration, and bit_rate may not be needed
          'format=filename,nb_streams,format_name,format_long_name,duration,size,bit_rate',
          'format_tags=creation_time',
          'stream=index,codec_name,codec_long_name,codec_type,codec_tag_string,width,height,color_range,display_aspect_ratio,r_frame_rate,bit_rate,sample_rate,channels,duration',
          'stream_tags=creation_time'
        ]
      );
      _videoDetails = VideoDetails.fromJson(jsonDecode(videoDetailsStr));
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
            Text('Filename', style: FluentTheme.of(context).typography.bodyStrong, maxLines: 2, overflow: TextOverflow.ellipsis,),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(_videoDetails.format!.filename!, style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text('Duration', style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(_videoDetails.format!.duration!, style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text('Format', style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(_videoDetails.format!.formatName!, style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text('Codec', style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(_videoDetails.streams![0].codecName!, style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text('Resolution', style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(
              _videoDetails.streams![0].width != null && _videoDetails.streams![0].height != null ? '${_videoDetails.streams![0].width!}x${_videoDetails.streams![0].height!} px' : 'N/A',
              style: FluentTheme.of(context).typography.body
            )
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text('Total Bit Rate', style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text('${(int.parse(_videoDetails.format!.bitRate!) / 1000).round()} kb/s', style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text('Size', style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text('${(int.parse(_videoDetails.format!.size!) / 1000000).round()} MB', style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text('Stream Count', style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(_videoDetails.format!.nbStreams!.toString(), style: FluentTheme.of(context).typography.body)
          ]
        ),
        rowSpacer,
        TableRow(
          children: [
            Text('Created Time', style: FluentTheme.of(context).typography.bodyStrong),
            Text(':', style: FluentTheme.of(context).typography.body,),
            Text(_videoDetails.format!.tags!.creationTime != null ? _videoDetails.format!.tags!.creationTime!.toString() : 'N/A', style: FluentTheme.of(context).typography.body)
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