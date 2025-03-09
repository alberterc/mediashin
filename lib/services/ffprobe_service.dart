import 'dart:io';

import 'package:path/path.dart' as p;

class FfprobeService {
  static Future<bool> isInstalled() async {
    final res = await Process.run('ffprobe', ['-version']);
    if (res.exitCode == 0 && res.stdout.toString().contains('ffprobe')) {
      return true;
    }

    final pathEnv = Platform.environment['PATH'];
    if (pathEnv != null) {
      for (String path in pathEnv.split(';')) {
        if (File(p.join(path, 'ffprobe.exe')).existsSync()) {
          return true;
        }
      }
    }

    return false;
  }

  Future<double> getTotalDuration({required String filePath}) async {
    final ffprobe = FfprobeService();
    final res = await ffprobe.run(
        filePath: filePath,
        printFormat: 'compact',
        useSexagesimal: false,
        entries: ['format=duration']);

    if (res.isNotEmpty) {
      return double.parse(res.split('=').removeLast());
    } else {
      return 0.0;
    }
  }

  Future<String> run(
      {required String filePath,
      required String printFormat,
      required bool useSexagesimal,
      required List<String> entries}) async {
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

    final exe = 'ffprobe ${args.join(' ')}';

    final res = await Process.run(exe, []);
    return res.stdout.toString();
  }
}
