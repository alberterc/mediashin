import 'dart:convert';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:mediashin/models/collections/colors.dart';
import 'package:mediashin/services/ffmpeg.dart';
import 'package:mediashin/services/ffprobe.dart';
import 'package:mediashin/utils/select_video_file.dart';
import 'package:mediashin/models/collections/statics.dart';
import 'package:mediashin/widgets/window_title_bar.dart';
import 'package:mediashin/models/video_details.dart';
import 'package:mime/mime.dart';
import 'package:window_manager/window_manager.dart';

class ExtractPage extends StatefulWidget {
  const ExtractPage({super.key});

  @override
  State<ExtractPage> createState() => _ExtractPageState();
}

class _ExtractPageState extends State<ExtractPage> with WindowListener {
  bool _isFilePicked = false;
  bool _draggingFile = false;
  bool _canConvert = false;
  static const _kSimpleDetailContainerWidth = 500.0;

  String _filePath = '';
  String _inputFileName = '';

  String _audioCodec = '';
  String _outputFileName = '';

  BuildContext? extractDialogContext;

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
          'Extract',
          style: FluentTheme.of(context).typography.title,
        ),
        spacer,
        Expanded(
          child: SingleChildScrollView(
            child: DropTarget(
              onDragDone: (details) {
                if (details.files.length == 1) {
                  setState(() {
                    _filePath = details.files.first.path;
                    _inputFileName =
                        details.files.first.path.split('\\').removeLast();
                    _isFilePicked = true;
                  });
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
              child: _buildBody(context),
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
              color: _draggingFile
                  ? Colors.white.withOpacity(0.15)
                  : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(7.0)),
          child: _isFilePicked
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: spacerInColumn(10, [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Input file: '),
                              SizedBox(
                                width: 250,
                                child: Tooltip(
                                  message: _filePath,
                                  style: const TooltipThemeData(
                                      waitDuration: Duration()),
                                  child: Text(
                                    _inputFileName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Detected audio codec: '),
                              FutureBuilder(
                                  future:
                                      _getAudioCodecsFromVideoFile(_filePath),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.data!.isNotEmpty) {
                                        _audioCodec = snapshot.data!.first;
                                        var codecs = '';
                                        if (snapshot.data!.length > 1) {
                                          for (var codec in snapshot.data!) {
                                            codecs += '$codec, ';
                                          }
                                          codecs = codecs.substring(
                                              0, codecs.length - 2);
                                        } else {
                                          codecs = snapshot.data!.first;
                                        }
                                        return Text(codecs);
                                      } else {
                                        return const Text(
                                            'No audio codecs found.');
                                      }
                                    } else {
                                      return const Text(
                                          'Analyzing input video file...');
                                    }
                                  })
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Output file name: '),
                                    const SizedBox(height: 5.0),
                                    Text(
                                      'Extracted file will be in the same directory of the selected file',
                                      style: FluentTheme.of(context)
                                          .typography
                                          .caption!
                                          .copyWith(
                                              color: Colors.white
                                                  .withOpacity(0.5)),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 200,
                                child: TextBox(
                                    onChanged: (value) {
                                      _outputFileName = value;
                                      _checkCanExtract();
                                    },
                                    placeholder:
                                        'file name (without file type)',
                                    expands: false,
                                    maxLines: 1),
                              )
                            ],
                          )
                        ]),
                      ),
                    ),
                    divider,
                    _canConvert
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 4.0),
                                child: _hyperlinkButton(
                                  text: 'Extract Audio',
                                  onPressed: () {
                                    if (_filePath != '' &&
                                        _outputFileName != '') {
                                      _extractAudioFromVideoFile(_filePath);
                                    }
                                  },
                                ),
                              ),
                              _hyperlinkButton(
                                text: 'Change Video File',
                                onPressed: () {
                                  selectVideoFile().then((file) {
                                    if (file != '') {
                                      setState(() {
                                        _filePath = file;
                                        _inputFileName =
                                            file.split('\\').removeLast();
                                        _isFilePicked = true;
                                      });
                                    }
                                    _checkCanExtract();
                                  });
                                },
                              ),
                            ],
                          )
                        : _hyperlinkButton(
                            text: 'Change Video File',
                            onPressed: () {
                              selectVideoFile().then((file) {
                                if (file != '') {
                                  setState(() {
                                    _filePath = file;
                                    _inputFileName =
                                        file.split('\\').removeLast();
                                    _isFilePicked = true;
                                  });
                                }
                                _checkCanExtract();
                              });
                            },
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
                                setState(() {
                                  _filePath = file;
                                  _inputFileName =
                                      file.split('\\').removeLast();
                                  _isFilePicked = true;
                                });
                              }
                              _checkCanExtract();
                            });
                          }),
                    ),
                    Text(
                      'or drop a video file here',
                      style: FluentTheme.of(context)
                          .typography
                          .caption!
                          .copyWith(color: Colors.white.withOpacity(0.5)),
                    )
                  ],
                )),
    );
  }

  Widget _hyperlinkButton({VoidCallback? onPressed, String? text}) {
    return HyperlinkButton(
      onPressed: onPressed ?? () {},
      child: SizedBox(
        width: _kSimpleDetailContainerWidth - 20,
        child: Text(text ?? 'Button',
            style: FluentTheme.of(context)
                .typography
                .body!
                .copyWith(color: AppColors.accentText)),
      ),
    );
  }

  Future<List<String>> _getAudioCodecsFromVideoFile(String filePath) async {
    if (lookupMimeType(filePath)!.startsWith('video/')) {
      // get audio codec
      final ffprobe = Ffprobe();
      var videoDetailsStr = await ffprobe.run(
          printFormat: 'json',
          filePath: filePath,
          useSexagesimal: true,
          entries: ['stream=codec_name,codec_type']);
      var videoDetails = VideoDetails.fromJson(jsonDecode(videoDetailsStr));
      List<String> videoStreamAudioCodecs = [];
      for (var stream in videoDetails.streams!) {
        if (stream.codecType == 'audio' && stream.codecName != null) {
          if (!videoStreamAudioCodecs.contains(stream.codecName!)) {
            videoStreamAudioCodecs.add(stream.codecName!);
          }
        }
      }
      return videoStreamAudioCodecs;
    }
    return [];
  }

  void _extractAudioFromVideoFile(String filePath) async {
    if (lookupMimeType(filePath)!.startsWith('video/')) {
      final dir = filePath.split('\\');
      dir.removeLast();
      _outputFileName += '.$_audioCodec';
      final outputFileNameFinal = '${dir.join('\\')}\\$_outputFileName';

      double convertProgress = 0.0;
      StateSetter progressSetstate = (fn) {};

      showDialog(
          context: context,
          barrierDismissible: false,
          dismissWithEsc: false,
          builder: (dialogContext) {
            extractDialogContext = dialogContext;
            return ContentDialog(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Processing...'),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 330,
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        progressSetstate = setState;
                        return ProgressBar(
                          value: convertProgress,
                        );
                      },
                    ),
                  ),
                ],
              ),
              content: Text(
                  'Extracting audio from "$_inputFileName" to "$_outputFileName".'),
              actions: [
                HyperlinkButton(
                  child: const Padding(
                    padding: kDefaultButtonPadding,
                    child: Text('Cancel'),
                  ),
                  onPressed: () {
                    if (extractDialogContext != null &&
                        extractDialogContext!.mounted) {
                      Navigator.pop(extractDialogContext!);
                    }
                  },
                )
              ],
            );
          });

      // get total duration of video stream
      final ffprobe = Ffprobe();
      final totalDuration = await ffprobe.getTotalDuration(filePath: filePath);

      // extract audio based on the found codec
      final ffmpeg = Ffmpeg();
      final res = await ffmpeg.extractAudio(
        filePath: filePath,
        outputFileNameWithPath: outputFileNameFinal,
      );

      // get extract progress
      await res.stdout.transform(utf8.decoder).forEach((line) {
        if (line.contains('out_time_ms')) {
          try {
            final currentDuration =
              double.parse(line.split('\n')[6].split('=').removeLast());
            progressSetstate(() {
              convertProgress = (currentDuration / 1000000 / totalDuration) * 100;
            });
          } catch(_) {}
        }
      });

      // after extract is done
      if (extractDialogContext != null && extractDialogContext!.mounted) {
        Navigator.pop(extractDialogContext!);
      }
      if (await res.exitCode == 0) {
        showDialog(
            context: context.mounted ? context : context,
            barrierDismissible: false,
            dismissWithEsc: false,
            builder: (dialogContext) {
              return ContentDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Successful'),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(
                        FluentIcons.check_mark,
                        size: 12,
                      ),
                    ),
                  ],
                ),
                content: Text(
                  'Successfully extracted audio from "$_inputFileName" to "$_outputFileName".',
                ),
                actions: [
                  HyperlinkButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Padding(
                      padding: kDefaultButtonPadding,
                      child: Text('OK'),
                    ),
                  )
                ],
              );
            });
      } else {
        showDialog(
            context: context.mounted ? context : context,
            barrierDismissible: false,
            dismissWithEsc: false,
            builder: (dialogContext) {
              return ContentDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Failed'),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(
                        FluentIcons.chrome_close,
                        size: 12,
                      ),
                    )
                  ],
                ),
                content: Text(
                    'Failed to extract audio from "$_inputFileName" to "$_outputFileName".'),
                actions: [
                  HyperlinkButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Padding(
                      padding: kDefaultButtonPadding,
                      child: Text('OK'),
                    ),
                  )
                ],
              );
            });
      }
      res.kill();
      _outputFileName = _outputFileName.split('.')[0];
    }
  }

  void _checkCanExtract() {
    if (_isFilePicked && _outputFileName != '') {
      setState(() {
        _canConvert = true;
      });
    } else {
      setState(() {
        _canConvert = false;
      });
    }
  }
}
