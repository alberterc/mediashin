import 'dart:io';

import 'package:path/path.dart' as p;

class Ffmpeg {
  Future<Process> convert({
    required String filePath,
    required String outputFileNameWithPath,
    String? vcodec,
    String? acodec,
    String? preset,
    String? sizeLimit,
    String? videoRateValue,
    String? videoBitrateControl
  }) async {
    List<String> args = [
      '-loglevel error',
      '-i "$filePath"',
      '-c:v $vcodec',
      '-c:a $acodec',
      '-preset $preset',
      '-progress -'
    ];
    final processDir = p.dirname(Platform.resolvedExecutable);
    final assetsPath = p.join(processDir, 'data\\flutter_assets\\assets');

    if (sizeLimit != null) {
      args.add('-fs $sizeLimit');
    }

    if (vcodec != null && vcodec.contains('nvenc')) {
      if (videoBitrateControl != 'crf' && videoRateValue != null) {
        args.addAll([
          '-cq:v $videoRateValue',
          '-rc:v $videoBitrateControl'
        ]);
      }
    }
    else {
      if (videoBitrateControl == 'crf' && videoRateValue != null) {
        args.add('-crf $videoRateValue');
      }
    }
    args.add('"$outputFileNameWithPath"'); // outputFilePath must be the last arg

    final exe = '${p.join(assetsPath, 'bin', 'ffmpeg.exe')} ${args.join(' ')}';
    final res = await Process.start(exe, []);

    return res;
  }
}