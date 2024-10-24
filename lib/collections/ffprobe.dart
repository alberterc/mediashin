import 'dart:io';

import 'package:path/path.dart' as p;

class Ffprobe {
  Future<double> getTotalDuration({
    required String filePath
  }) async {
    final ffprobe = Ffprobe();
    final res = await ffprobe.run(
      filePath: filePath,
      printFormat: 'compact',
      useSexagesimal: false,
      entries: ['format=duration']
    );

    if (res.isNotEmpty) {
      return double.parse(res.split('=').removeLast());
    }
    else {
      return 0.0;
    }
  }

  Future<String> run({
    required String filePath,
    required String printFormat,
    required bool useSexagesimal,
    required List<String> entries
  }) async {
    List<String> args = [
      '-of $printFormat',
      '-i "$filePath"',
      '-v quiet',
      '-show_error',
      '-show_entries ${entries.join(':')}'
    ];

    if (useSexagesimal) {
      args.add('-sexagesimal');
    }

    final processDir = p.dirname(Platform.resolvedExecutable);
    final assetsPath = p.join(processDir, 'data\\flutter_assets\\assets');
    final exe = '${p.join(assetsPath, 'bin', 'ffprobe.exe')} ${args.join(' ')}';

    final res = await Process.run(exe, []);
    return res.stdout.toString();
  }
}