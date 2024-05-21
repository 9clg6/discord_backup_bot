import 'package:collection/collection.dart';
import 'package:nyxx/nyxx.dart';
import 'package:logger/logger.dart' as logger;

import '../exceptions/exceptions.dart';
import '../share/share.constants.dart';
import '../use_case/enum/parameters.enum.dart';
import '../utils/printer.util.dart';
import 'export.service.dart';
import 'logger.service.dart';
import 'restartable_timer.dart';

///
/// [CoreService]
///
class CoreService {
  final Map<int, bool> _isServerInitMap = {};

  final Map<int, RestartableTimer> _timerMap = {};

  ///
  /// Private constructor to prevent external instantiation.
  ///
  CoreService._();

  /// The single instance of the class.
  static final CoreService _instance = CoreService._();

  ///
  /// Factory constructor to provide access to the singleton instance.
  ///
  factory CoreService() {
    return _instance;
  }

  ///
  /// isInitialized
  ///
  Future<bool> isInitialized(int serverId) async {
    bool? isInit;

    if (_isServerInitMap[serverId] == true) {
      isInit = true;
    } else if (_isServerInitMap[serverId] == null) {
      final Map<String, dynamic>? lastDoc =
          (await supabase.from(initCollectionKey).select().eq(
                    'serverId',
                    serverId,
                  ))
              .firstOrNull;

      if (lastDoc == null) {
        isInit = false;
      } else {
        final bool inter = lastDoc['isInitialized'] as bool;

        if (inter == true && _isServerInitMap[serverId] == null) {
          isInit = false;
        } else {
          isInit = inter;
        }
      }
    } else {
      ///TODO CANCEL BACKUP
    }

    return isInit!;
  }

  void startCron(
    Parameters? parameters,
    int serverId,
    int channelId, {
    required String publicKey,
  }) {
    final RestartableTimer timer = RestartableTimer(
      Duration(days: 1),
      () async {
        await ExportService(
          serverId,
          channelId,
          publicKey: publicKey,
        ).processExport(
          parameters ?? Parameters.noParameter,
        );
      },
      serverId,
    )..start();

    _timerMap[serverId] = timer;
  }

  ///
  /// Initialize bot
  ///
  Future<void> initialize(
    int id, {
    int? channelId,
    int? code,
    bool? initValue,
    String? publicKey,
  }) async {
    try {
      await supabase.from(initCollectionKey).upsert({
        "serverId": id,
        "channelId": channelId,
        "parameter": code,
        "isInitialized": initValue ?? true,
        "publicKey": publicKey,
      });

      _isServerInitMap[id] = initValue ?? true;
    } on Exception catch (_) {
      throw InitializationException("❌ L'initialisation a échoué");
    }
  }

  ///
  /// Remove guild from database
  ///
  ///TODO REMOVAL NOT WORKING
  Future<void> removeGuild(int serverId) async {
    return supabase.from(initCollectionKey).delete().eq('serverId', serverId);
  }

  ///
  /// Initialize CRON at bot start
  ///
  Future<void> initializeAtStart(NyxxGateway client) async {
    final List<Map<String, dynamic>> initializedServer =
        await supabase.from(initCollectionKey).select();

    for (Map<String, dynamic> server in initializedServer) {
      final int serverId = server["serverId"] as int;
      final int channelId = server["channelId"] as int;
      final String publicKey = server["publicKey"] as String;

      try {
        await client.guilds.get(Snowflake.parse(channelId));
      } on Exception catch (_) {
        LoggerService(0).writeLog(
          logger.Level.error,
          "❌ Le bot n'est plus présent sur ce serveur ($serverId), impossible d'initialiser, suppression de la base (init). ",
        );
        await removeGuild(channelId);
        continue;
      }

      if (!(server["isInitialized"] as bool)) continue;

      startCron(
        Parameters.values.firstWhereOrNull(
                (element) => element.code == server["parameter"] as int) ??
            Parameters.noParameter,
        serverId,
        channelId,
        publicKey: publicKey,
      );

      _isServerInitMap[serverId] = true;

      await writeMessageWithChannelId(
        channelId,
        serverId,
        "💡 Démarrage du processus de sauvegarde en arrière-plan.",
      );
    }
  }

  Future<void> stopServices(int serverId) async {
    final RestartableTimer? timer = _timerMap[serverId];

    if (timer == null) throw CancelBotException("Serveur non-initialisé");

    timer.cancel();
    _isServerInitMap[serverId] = false;
    await initialize(serverId, initValue: false);
  }
}
