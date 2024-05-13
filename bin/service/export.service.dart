import 'dart:convert';
import 'dart:io';

import 'package:nyxx/nyxx.dart';
import '../entity/guild_export.entity.dart';
import '../share/share.constants.dart';
import '../use_case/enum/parameters.enum.dart';
import '../use_case/export/fetch_channels.use_case.dart';
import '../use_case/export/fetch_roles.use_case.dart';
import '../utils/elapsed.util.dart';
import '../utils/printer.util.dart';
import 'logger.service.dart';
import 'package:logger/logger.dart' as logger;

///
/// [ExportService]
///
class ExportService {
  /// Channel id
  final int channelId;

  /// Server id
  final int serverId;

  ///
  /// Export service
  ///
  ExportService._(
    this.serverId,
    this.channelId,
  );

  ///
  /// Fatory
  ///
  factory ExportService(
    int serverId,
    int channelId,
  ) =>
      ExportService._(
        serverId,
        channelId,
      );

  ///
  /// Process export
  ///
  Future<void> processExport(Parameters parameters) async {
    final Stopwatch sw = Stopwatch();

    LoggerService(serverId).writeLog(
      logger.Level.info,
      "🚴‍♂️ [${DateTime.now().toIso8601String()}] Démarrage du processus d'export",
    );

    await writeMessageWithChannelId(
      channelId,
      serverId,
      "Démarrage du processus d'export...",
    );

    PartialGuild? partialGuild;

    try {
      partialGuild = await client.guilds.get(Snowflake.parse(serverId));
    } on Exception catch (_) {
      LoggerService(serverId).writeLog(
        logger.Level.error,
        "❌ Serveur inconnu [Fin du processus d'import]",
      );
      return;
    }

    // Démarrer le Stopwatch juste avant l'exécution de la sauvegarde
    sw.start();

    try {
      final GuildExport guildExport = GuildExport(
        guildName: (await partialGuild.fetch()).name,
        guildId: serverId,
        roles: await FetchRolesUseCase.fetchRoles(partialGuild),
        chans: await FetchChannelsUseCase.fetchChans(
          partialGuild,
          noMessageSave: parameters == Parameters.noMessageSave,
        ),
      );

      LoggerService(serverId).writeLog(
        logger.Level.info,
        "📑 Sauvegarde en cours...",
      );

      try {
        await supabase.from(saveCollectionKey).upsert({
          "server": base64.encode(
            gzip.encode(
              utf8.encode(
                jsonEncode(
                  guildExport.toJson(),
                ),
              ),
            ),
          ),
          "serverName": guildExport.guildName,
          "id": "${DateTime.now().millisecondsSinceEpoch}",
          "serverId": guildExport.guildId,
        });

        LoggerService(serverId).writeLog(
          logger.Level.info,
          "📑✅ Sauvegarde OK",
        );

        await writeMessageWithChannelId(
          channelId,
          serverId,
          "**La sauvegarde du jour vient d'être effectuée en ${elapsedString(sw.elapsed)}**",
        );
      } on Exception catch (e) {
        LoggerService(serverId).writeLog(
          logger.Level.error,
          "❌ Impossible d'effectuer la sauvegarde (${e.toString()})",
        );

        await writeMessageWithChannelId(
          channelId,
          serverId,
          "** ❌ Une erreur s'est produite lors de la sauvegarde ❌ (${e.toString()}) **",
        );
      }
    } on Exception catch (e) {
      await writeMessageWithChannelId(
        channelId,
        serverId,
        "** ❌ Une erreur s'est produite lors de l'export ❌ (${e.toString()}) **",
      );
    } finally {
      sw.stop();
    }
  }
}
