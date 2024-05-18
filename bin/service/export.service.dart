import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:nyxx/nyxx.dart';
import '../entity/guild_export.entity.dart';
import '../share/share.constants.dart';
import '../use_case/enum/parameters.enum.dart';
import '../use_case/export/fetch_channels.use_case.dart';
import '../use_case/export/fetch_roles.use_case.dart';
import '../utils/elapsed.util.dart';
import '../utils/key.util.dart';
import '../utils/printer.util.dart';
import 'logger.service.dart';
import 'package:logger/logger.dart' as logger;
import 'package:pointycastle/asymmetric/api.dart';

///
/// [ExportService]
///
class ExportService {
  /// Channel id
  final int channelId;

  /// Server id
  final int serverId;

  /// RSA public key
  final String publicKey;

  ///
  /// Export service
  ///
  ExportService._(
    this.serverId,
    this.channelId,
    this.publicKey,
  );

  ///
  /// Factory
  ///
  factory ExportService(
    int serverId,
    int channelId, {
    required String publicKey,
  }) =>
      ExportService._(
        serverId,
        channelId,
        publicKey,
      );

  ///
  /// Process export
  ///
  Future<void> processExport(Parameters parameters) async {
    final Stopwatch sw = Stopwatch();

    late RSAPublicKey pK;

    LoggerService(serverId).writeLog(
      logger.Level.info,
      "🚴‍♂️ Démarrage du processus d'export",
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
        pK = RSAKeyParser().parse(formatPublicPem(publicKey)) as RSAPublicKey;
      } catch (e) {
        LoggerService(serverId).writeLog(
          logger.Level.error,
          "❌ Clé public RSA au mauvais format ($publicKey)",
        );
        await writeMessageWithChannelId(
          channelId,
          serverId,
          "❌ La clé public RSA ne possède pas le bon format, vérifiez la ou regénérez la.",
        );
        return;
      }

      try {
        final aesKey = Key.fromSecureRandom(32); // AES 256 bits
        final iv = IV.fromSecureRandom(16); // IV 128 bits

        final Encrypter publicKeyEncrypter = Encrypter(RSA(publicKey: pK));
        final Encrypter aesEncrypter = Encrypter(
          AES(
            aesKey,
            mode: AESMode.cbc,
          ),
        );

        final encryptedAesKey = publicKeyEncrypter.encrypt(aesKey.base64);

        // Ajout du IV dans le stockage pour l'utiliser lors de la décryption
        final encryptedData = aesEncrypter.encrypt(
          base64.encode(
            gzip.encode(
              utf8.encode(jsonEncode(guildExport.toJson())),
            ),
          ),
          iv: iv,
        );

        await supabase.from(saveCollectionKey).upsert({
          "server": encryptedData.base64,
          "serverName": guildExport.guildName,
          "id": "${DateTime.now().millisecondsSinceEpoch}",
          "serverId": guildExport.guildId,
          "encryptedAes": encryptedAesKey.base64,
          "iv": iv.base64,
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
