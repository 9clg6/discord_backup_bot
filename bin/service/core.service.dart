import 'package:collection/collection.dart';
import 'package:nyxx/nyxx.dart';
import 'package:logger/logger.dart' as logger;

import '../entity/supabase/initialize.dart';
import '../entity/supabase/white_listed_user.dart';
import '../exceptions/exceptions.dart';
import '../share/share.constants.dart';
import '../use_case/enum/parameters.enum.dart';
import '../utils/printer.util.dart';
import 'changelog.service.dart';
import 'database.service.dart';
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
      final Initialize? initializeResult =
          await DatabaseService().fetchDocument<Initialize>(
        initCollectionKey,
        serverIdKey,
        serverId,
        Initialize.fromJson,
      );

      if (initializeResult == null) {
        isInit = false;
      } else {
        if (initializeResult.isInitialized == true &&
            _isServerInitMap[serverId] == null) {
          isInit = false;
        } else {
          isInit = initializeResult.isInitialized;
        }
      }
    } else {
      isInit = false;
    }

    return isInit;
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
      DatabaseService().saveData(
        Initialize(
          serverId: id,
          channelId: channelId ?? 0,
          parameter: code ?? Parameters.noParameter.code,
          isInitialized: initValue ?? false,
          publicKey: publicKey ?? '',
        ),
        collection: initCollectionKey,
      );

      _isServerInitMap[id] = initValue ?? true;
    } on Exception catch (_) {
      throw InitializationException("❌ L'initialisation a échoué");
    }
  }

  ///
  /// Is given user white listed
  ///
  Future<bool> isInWhiteList(int userId) async {
    return (await DatabaseService().fetchDocument<WhiteListedUser>(
          whiteListCollectionKey,
          userIdWhiteListKey,
          userId,
          WhiteListedUser.fromJson,
        ))
            ?.isWhiteListed ??
        false;
  }

  ///
  /// Remove guild from database
  ///
  ///TODO REMOVAL NOT WORKING
  Future<void> removeGuild(int serverId) async {
    ///return supabase.from(initCollectionKey).delete().eq('serverId', serverId);
  }

  ///
  /// Initialize CRON at bot start
  ///
  Future<void> initializeAtStart(NyxxGateway client) async {
    final List<Initialize>? initializedServer =
        await DatabaseService().fetchDocuments(
      initCollectionKey,
      Initialize.fromJson,
    );

    if (initializedServer == null || initializedServer.isEmpty) return;

    for (Initialize server in initializedServer) {
      try {
        await client.guilds.get(Snowflake.parse(server.channelId));
      } on Exception catch (_) {
        LoggerService(0).writeLog(
          logger.Level.error,
          save: true,
          print: false,
          "❌ Le bot n'est plus présent sur ce serveur (${server.serverId}), impossible d'initialiser, suppression de la base (init). ",
        );
        await removeGuild(server.channelId);
        continue;
      }

      if (!(server.isInitialized)) continue;

      startCron(
        Parameters.values.firstWhereOrNull(
                (element) => element.code == server.parameter) ??
            Parameters.noParameter,
        server.serverId,
        server.channelId,
        publicKey: server.publicKey,
      );

      final ChangeLogService changeLogService = ChangeLogService(
        server.serverId,
        server.channelId,
      )..getLatestChangelog();

      final String? lastVersionSeen = await changeLogService.fetchVersion();

      if (lastVersionSeen == null ||
          changeLogService.currentVersion != lastVersionSeen) {
        await writeMessageWithChannelId(
          server.channelId,
          server.serverId,
          changeLogService.changelog.toString(),
        );
        changeLogService.saveState();
      }

      _isServerInitMap[server.serverId] = true;

      await writeMessageWithChannelId(
        server.channelId,
        server.serverId,
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
