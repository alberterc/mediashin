import 'dart:convert';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:mediashin/models/collections/colors.dart';
import 'package:mediashin/services/ffmpeg.dart';
import 'package:mediashin/services/ffprobe.dart';
import 'package:mediashin/utils/select_video_file.dart';
import 'package:mediashin/models/collections/statics.dart';
import 'package:mediashin/widgets/window_title_bar.dart';
import 'package:mime/mime.dart';
import 'package:window_manager/window_manager.dart';

class ConvertPage extends StatefulWidget {
  const ConvertPage({super.key});

  @override
  State<ConvertPage> createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> with WindowListener {
  bool _isFilePicked = false;
  bool _draggingFile = false;
  bool _canConvert = false;
  static const _kSimpleDetailContainerWidth = 500.0;

  String _filePath = '';
  String _inputFileName = '';

  bool _doLimitOutputSize = false;
  bool _doChangeVideoRate = false;
  String _fileSizeLimitUnit = 'KB';
  String _fileSizeLimit = '';
  String _videoCodec = 'copy';
  String _audioCodec = 'copy';
  String _encodePreset = 'medium';
  String _videoRateValue = '24';
  String _videoBitrateControl = 'crf';
  String _outputFileName = '';

  BuildContext? convertingDialogContext;

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
          'Convert',
          style: FluentTheme.of(context).typography.title
        ),
        spacer,
        Expanded(
          child: SingleChildScrollView(
            child: DropTarget(
              onDragDone: (details) {
                if (details.files.length == 1) {
                  setState(() {
                    _filePath = details.files.first.path;
                    _inputFileName = details.files.first.path.split('\\').removeLast();
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
          )
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: spacerInColumn(10, [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Input file:'),
                      _isFilePicked
                      ? SizedBox(
                          width: 250,
                          child: Tooltip(
                            message: _filePath,
                            style: const TooltipThemeData(
                              waitDuration: Duration()
                            ),
                            child: Text(
                              _inputFileName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right
                            ),
                          ),
                        )
                      : Text('No file selected', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Output file name:'),
                      SizedBox(
                        width: 200,
                        child: TextBox(
                          onChanged: (value) {
                            _outputFileName = value;
                            _checkCanConvert();
                          },
                          placeholder: 'file name.mp4',
                          expands: false,
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Video codec:',
                      ),
                      ComboBox(
                        value: _videoCodec,
                        onChanged: (val) {
                          setState(() {
                            _videoCodec = val!;
                          });
                        },
                        items: videoCodec.map((val) {
                          return ComboBoxItem(
                            value: val,
                            child: Text(val),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Audio codec:',
                      ),
                      ComboBox(
                        value: _audioCodec,
                        onChanged: (val) {
                          setState(() {
                            _audioCodec = val!;
                          });
                        },
                        items: audioCodec.map((val) {
                          return ComboBoxItem(
                            value: val,
                            child: Text(val),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Preset:',
                      ),
                      ComboBox(
                        value: _encodePreset,
                        onChanged: (val) {
                          setState(() {
                            _encodePreset = val!;
                          });
                        },
                        items: ffmpegEncodePreset.map((val) {
                          return ComboBoxItem(
                            value: val,
                            child: Text(val),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Limit output size?'),
                      ToggleSwitch(
                        checked: _doLimitOutputSize,
                        onChanged: (val) {
                          setState(() {
                            _doLimitOutputSize = val;
                          });
                        },
                      ),
                    ],
                  ),
                  _videoLimitOutputSizeContainer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Change video rate?'),
                      ToggleSwitch(
                        checked: _doChangeVideoRate,
                        onChanged: (val) {
                          setState(() {
                            _doChangeVideoRate = val;
                          });
                        },
                      ),
                    ],
                  ),
                  _videoBitrateControlContainer(),
                ])
              ),
            ),
            divider,
            _canConvert && _isFilePicked
            ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: _hyperlinkButton(
                    text: 'Convert',
                    onPressed: () {
                      if (_filePath != '' && _outputFileName != '') {
                        _convertVideoFile(_filePath);
                      }
                    }
                  ),
                ),
                _hyperlinkButton(
                  text: 'Change Video File',
                  onPressed: () {
                    selectVideoFile().then((file) {
                      if (file != '') {
                        setState(() {
                          _filePath = file;
                          _inputFileName = file.split('\\').removeLast();
                          _isFilePicked = true;
                        });
                      }
                      _checkCanConvert();
                    });
                  }
                ),
              ],
            )
            : !_canConvert && _isFilePicked
            ? Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: _hyperlinkButton(
                text: 'Change Video File',
                onPressed: () {
                  selectVideoFile().then((file) {
                    if (file != '') {
                      setState(() {
                        _filePath = file;
                        _inputFileName = file.split('\\').removeLast();
                        _isFilePicked = true;
                      });
                    }
                    _checkCanConvert();
                  });
                }
              ),
            )
            : Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: _hyperlinkButton(
                text: 'Select a Video File',
                onPressed: () {
                  selectVideoFile().then((file) {
                    if (file != '') {
                      setState(() {
                        _filePath = file;
                        _inputFileName = file.split('\\').removeLast();
                        _isFilePicked = true;
                      });
                    }
                    _checkCanConvert();
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

  void _convertVideoFile(String filePath) async {
    if (lookupMimeType(filePath)!.startsWith('video/')) {
      final dir = filePath.split('\\');
      dir.removeLast();
      final outputFileNameFinal = '${dir.join('\\')}\\$_outputFileName';

      double convertProgress = 0.0;
      StateSetter progressSetstate = (fn) {};

      showDialog(
        context: context,
        barrierDismissible: false,
        dismissWithEsc: false,
        builder: (dialogContext) {
          convertingDialogContext = dialogContext;
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
                  )
                ),
              ],
            ),
            content: Text(
              'Converting "$_inputFileName" to "$_outputFileName".',
            ),
            actions: [
              HyperlinkButton(
                child: const Padding(
                  padding: kDefaultButtonPadding,
                  child: Text('Cancel')
                ),
                onPressed: () {
                  if (convertingDialogContext != null && convertingDialogContext!.mounted) {
                    Navigator.pop(convertingDialogContext!);
                  }
                },
              )
            ],
          );
        }
      );

      // get total duration of video stream
      final ffprobe = Ffprobe();
      final totalDuration = await ffprobe.getTotalDuration(filePath: filePath);

      // run convert
      final ffmpeg = Ffmpeg();
      final res = await ffmpeg.convert(
        filePath: filePath,
        outputFileNameWithPath: outputFileNameFinal,
        vcodec: _videoCodec,
        acodec: _audioCodec,
        preset: _encodePreset,
        sizeLimit: _doLimitOutputSize && _fileSizeLimit != '' ? _fileSizeLimit : null,
        videoRateValue: _doChangeVideoRate && _videoRateValue != '' ? _videoRateValue : null,
        videoBitrateControl: _doChangeVideoRate ? _videoBitrateControl : null
      );

      // get convert progress
      await res.stdout
        .transform(utf8.decoder)
        .forEach(
          (line) {
            if (line.contains('out_time_ms')) {
              try {
                final currentDuration = double.parse(line.split('\n')[6].split('=').removeLast());
                progressSetstate(() {
                  convertProgress = (currentDuration / 1000000 / totalDuration) * 100;
                });
              } catch (_) {}
            }
          });

      // after convert is done
      if (convertingDialogContext != null && convertingDialogContext!.mounted) {
        Navigator.pop(convertingDialogContext!);
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
                      color: Colors.green,
                      shape: BoxShape.circle
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(
                      FluentIcons.check_mark,
                      size: 12,
                    ),
                  ),
                ],
              ),
              content: Text(
                'Successfully converted "$_inputFileName" to "$_outputFileName".',
              ),
              actions: [
                HyperlinkButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Padding(
                    padding: kDefaultButtonPadding,
                    child: Text('OK')
                  )
                )
              ]
            );
          }
        );
      }
      else {
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
                      color: Colors.red,
                      shape: BoxShape.circle
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(
                      FluentIcons.chrome_close,
                      size: 12,
                    ),
                  ),
                ],
              ),
              content: Text(
                'Failed to convert "$_inputFileName" to "$_outputFileName".',
              ),
              actions: [
                HyperlinkButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Padding(
                    padding: kDefaultButtonPadding,
                    child: Text('OK')
                  )
                )
              ]
            );
          }
        );
      }
      res.kill();
    }
  }

  void _checkCanConvert() {
    if (_isFilePicked && _outputFileName != '') {
      setState(() {
        _canConvert = true;
      });
    }
    else {
      setState(() {
        _canConvert = false;
      });
    }
  }

  Widget _videoLimitOutputSizeContainer() {
    if (_doLimitOutputSize) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'File size limit:'
          ),
          SizedBox(
            width: 170,
            child: TextBox(
              placeholder: 'value',
              enabled: _doLimitOutputSize,
              expands: false,
              maxLines: 1,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (value) {
                _fileSizeLimit = value;
              },
              suffix: ComboBox(
                value: _fileSizeLimitUnit,
                onChanged: (val) {
                  setState(() {
                    _fileSizeLimitUnit = val!;
                  });
                },
                items: fileSize.map((val) {
                  return ComboBoxItem(
                    value: val,
                    child: Text(val),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      );
    }
    else {
      return const SizedBox();
    }
  }

  Widget _videoBitrateControlContainer() {
    if (_doChangeVideoRate) {
      return Column(
        children: [
          const SizedBox(height: 6),
          _videoCodec.contains('nvenc')
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Video bitrate control:',
                ),
                ComboBox(
                  value: _videoBitrateControl,
                  onChanged: (val) {
                    setState(() {
                      _videoBitrateControl = val!;
                    });
                  },
                  items: ffmpegVideoBitrateControl.map((val) {
                    return ComboBoxItem(
                      value: val,
                      child: Text(val),
                    );
                  }).toList(),
                )
              ],
            )
          : const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Video bitrate control:',
                ),
                Text(
                  'crf'
                )
              ],
            ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Video rate value:',
              ),
              SizedBox(
                width: 70,
                child: TextBox(
                  placeholder: '24',
                  expands: false,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
                    _videoRateValue = value;
                  },
                ),
              )
            ],
          ),
        ],
      );
    }
    else {
      return const SizedBox();
    }
  }
}