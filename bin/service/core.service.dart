import 'package:collection/collection.dart';
import 'package:nyxx/src/client.dart';

import '../exceptions/exceptions.dart';
import '../share/share.constants.dart';
import '../use_case/enum/parameters.enum.dart';
import 'export.service.dart';
import 'restartable_timer.dart';

///
/// [CoreService]
///
class CoreService {
  final Map<int, bool> _isServerInitMap = {};

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
          (await supabase.from(initCollection).select().eq(
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
    int channelId,
  ) {
    RestartableTimer(
      Duration(days: 1),
      () async {
        await ExportService(
          serverId,
          channelId,
        ).processExport(
          parameters ?? Parameters.noParameter,
        );
      },
      serverId,
    ).start();
  }

  ///
  /// Initialize bot
  ///
  Future<void> initialize(
    int id,
    int channelId,
    int? code, {
    bool? initValue,
  }) async {
    try {
      await supabase.from(initCollection).upsert({
        "serverId": id,
        "channelId": channelId,
        "parameter": code,
        "isInitialized": initValue ?? true,
      });

      _isServerInitMap[id] = initValue ?? true;
    } on Exception catch (_) {
      throw InitializationResult("❌ L'initialisation a échoué");
    }
  }

  ///
  /// Initialize CRON at bot start
  ///
  Future<void> initializeAtStart(NyxxGateway client) async {
    final List<Map<String, dynamic>> initializedServer =
        await supabase.from(initCollection).select();

    for (Map<String, dynamic> server in initializedServer) {
      if (!(server["isInitialized"] as bool)) continue;

      startCron(
        Parameters.values.firstWhereOrNull(
                (element) => element.code == server["parameter"] as int) ??
            Parameters.noParameter,
        server["serverId"] as int,
        server["channelId"] as int,
      );

      _isServerInitMap[server["serverId"]] = true;
    }
  }
}
