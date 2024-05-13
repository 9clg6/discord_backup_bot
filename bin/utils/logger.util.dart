import 'dart:io';

import 'package:logger/logger.dart';

class FileLoggerOutput extends LogOutput {
  final int? serverId;

  FileLoggerOutput(this.serverId);

  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      print(line);
    }

    _writeLog(event.origin.message as String);
  }

  Future<void> _writeLog(String message) async {
    final DateTime currentDate = DateTime.now();
    final String dateString =
        "${currentDate.day}-${currentDate.month}-${currentDate.year}";

    final File file = File(
      serverId != null
          ? 'logs/log_${serverId}_$dateString.txt'
          : 'logs/log_$dateString.txt',
    );

    if (!(await file.exists())) {
      await file.create(recursive: true);
    }

    file.writeAsStringSync(
      "[${currentDate.hour}:${currentDate.minute}] $message\n",
      mode: FileMode.append,
    );
  }
}
