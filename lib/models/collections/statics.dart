import 'package:fluent_ui/fluent_ui.dart';

class MediashinFunction {
  final int id;
  final String name;
  final String desc;

  const MediashinFunction(this.id, this.name, this.desc);
}

final List<MediashinFunction> pages = [
  const MediashinFunction(0, 'Analyze', 'Get info about the video.'),
  const MediashinFunction(1, 'Convert', 'Convert video into another encoding.'),
  const MediashinFunction(
      2, 'Extract', 'Extract audio and video from the video.'),
];

List<Widget> spacerInColumn(double gap, Iterable<Widget> children) => children
    .expand((item) sync* {
      yield SizedBox(height: gap);
      yield item;
    })
    .skip(1)
    .toList();

final List<String> fileSize = ['KB', 'MB', 'GB', 'TB'];

final List<String> videoCodec = [
  'copy',
  'av1',
  'h264',
  'hevc',
  'hevc_nvenc',
  'h264_nvenc',
  'mpeg4',
  'vp8',
  'vp9',
];

final List<String> videoFormat = ['mp4', 'mkv'];

final List<String> audioCodec = [
  'copy',
  'aac',
  'avc',
  'mp3',
  'flac',
  'libvorbis',
  'libopus',
];

final List<String> ffmpegEncodePreset = [
  'ultrafast',
  'superfast',
  'veryfast',
  'faster',
  'fast',
  'medium',
  'slow',
  'slower',
  'veryslow',
  'placebo'
];

final List<String> ffmpegVideoBitrateControl = [
  'cbr',
  'vbr',
];
