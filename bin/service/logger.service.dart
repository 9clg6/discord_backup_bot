import 'package:logger/logger.dart';

import '../utils/logger.util.dart';

class LoggerService {
  late Logger _l;
  late Logger _lNoSave;
  int serverId;

  ///
  /// Private constructor to prevent external instantiation.
  ///
  LoggerService._(this.serverId) {
    _l = Logger(
      output: FileLoggerOutput(serverId),
      filter: ProductionFilter(),
      level: Level.all,
    );
    _lNoSave = Logger(
      filter: ProductionFilter(),
      level: Level.all,
    );
  }

  static final Map<int, LoggerService> _instances = {};

  ///
  /// Factory constructor to provide access to the singleton instance.
  ///
  factory LoggerService(int serverId) {
    _instances[serverId] ??= LoggerService._(serverId);
    return _instances[serverId]!;
  }

  void writeLog(
    Level level,
    String content, {
    bool save = true,
  }) {
    switch (level) {
      case Level.debug:
        if (save) {
          return _l.d(content);
        }
        return _lNoSave.d(content);
      case Level.info:
        if (save) {
          return _l.i(content);
        }
        return _lNoSave.i(content);
      case Level.warning:
        if (save) {
          return _l.w(content);
        }
        return _lNoSave.w(content);
      case Level.error:
        if (save) {
          return _l.e(content);
        }
        return _lNoSave.e(content);

      default:
        if (save) {
          return _l.i(content);
        }
        return _lNoSave.i(content);
    }
  }
}
