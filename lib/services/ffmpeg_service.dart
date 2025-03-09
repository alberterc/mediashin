import 'dart:io';

import 'package:path/path.dart' as p;

class FfmpegService {
  static Future<bool> isInstalled() async {
    final res = await Process.run('ffmpeg', ['-version']);
    if (res.exitCode == 0 && res.stdout.toString().contains('ffmpeg')) {
      return true;
    }

    final pathEnv = Platform.environment['PATH'];
    if (pathEnv != null) {
      for (String path in pathEnv.split(';')) {
        if (File(p.join(path, 'ffmpeg.exe')).existsSync()) {
          return true;
        }
      }
    }

    return false;
  }

  Future<Process> convert(
      {required String filePath,
      required String outputFileNameWithPath,
      String? vcodec,
      String? acodec,
      String? preset,
      String? sizeLimit,
      String? videoRateValue,
      String? videoBitrateControl,
      required bool addThumbnail}) async {
    List<String> thumbnailArgs = [
      '-filter_complex "[0:v]thumbnail,trim=end_frame=1,scale=320:-1[thumb]"',
      '-map "[thumb]"',
      '-disposition:v:1 attached_pic',
      '-c:v:1 mjpeg'
    ];

    List<String> args = [
      '-loglevel error',
      '-i "$filePath"',
      '-map_metadata 0',
      '-map 0',
      '-c:v:0 $vcodec',
      '-c:a $acodec',
      '-preset $preset',
      '-progress -'
    ];

    if (addThumbnail) {
      args.insertAll(4, thumbnailArgs);
    }

    if (sizeLimit != null) {
      args.add('-fs $sizeLimit');
    }

    if (vcodec != null && vcodec.contains('nvenc')) {
      if (videoBitrateControl != 'crf' && videoRateValue != null) {
        args.addAll(['-cq:v $videoRateValue', '-rc:v $videoBitrateControl']);
      }
    } else {
      if (videoBitrateControl == 'crf' && videoRateValue != null) {
        args.add('-crf $videoRateValue');
      }
    }
    args.add(
        '"$outputFileNameWithPath"'); // outputFilePath must be the last arg

    final exe = 'ffmpeg ${args.join(' ')}';
    final res = await Process.start(exe, []);

    return res;
  }

  Future<Process> extractAudio(
      {required String filePath,
      required String outputFileNameWithPath}) async {
    List<String> args = [
      '-loglevel error',
      '-i "$filePath"',
      '-c copy',
      '-progress -'
    ];

    args.add(
        '"$outputFileNameWithPath"'); // outputFilePath must be the last arg

    final exe = 'ffmpeg ${args.join(' ')}';
    final res = await Process.start(exe, []);

    return res;
  }
}
