import 'dart:io';

import 'package:path/path.dart' as p;

// TODO: embed prebuilt ffprobe.exe into assets or windows build directory
class Ffprobe {
  Future<String> run({
    required String filePath,
    required String printFormat,
    required List<String> entries
  }) async {
    List<String> args = [
      '-of $printFormat',
      '-i "$filePath"',
      '-v quiet',
      '-show_error',
      '-sexagesimal',
      '-show_entries ${entries.join(':')}'
    ];
    final processDir = p.dirname(Platform.resolvedExecutable);
    final exe = '${p.join(processDir, 'bin', 'ffprobe.exe')} ${args.join(' ')}';

    // print('[Run Process] $exe');

    final res = await Process.run(exe, []);
    return res.stdout.toString();
  }
}