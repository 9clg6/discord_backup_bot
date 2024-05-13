import 'dart:async';

import 'logger.service.dart';
import 'package:logger/logger.dart' as logger;

///
/// [RestartableTimer]
///
class RestartableTimer {
  /// Timer
  Timer? _timer;

  /// Frequency to execute callback
  final Duration _duration;

  /// Callback to execute periodically
  final Function() _callback;

  /// Is callback active
  bool _isActive = false;
  
  final int _serverId;

  ///
  /// Constructor
  ///
  RestartableTimer(
    this._duration,
    this._callback,
    this._serverId,
  );

  ///
  /// Start timer
  ///
  void start() {
    if (!_isActive) {
      LoggerService(_serverId).writeLog(
        logger.Level.info,
        "✅ Démarrage du service CRON",
      );

      _isActive = true;
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(_duration, (timer) async {
      try {
        await _callback();
      } catch (e) {
        LoggerService(_serverId).writeLog(
          logger.Level.error,
          "❌ Une erreur c'est produite... Redémarrage du service ($e)",
        );
        _timer?.cancel();
        _startTimer();
      }
    });
  }

  ///
  /// Cancel timer
  ///
  void cancel() {
    if (_isActive) {
      _isActive = false;
      _timer?.cancel();
    }
  }
}
