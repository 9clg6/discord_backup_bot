import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:pointycastle/asymmetric/api.dart';

import '../entity/guild_export.entity.dart';
import '../entity/supabase/export.dart';
import '../service/database.service.dart';
import '../service/logger.service.dart';
import '../share/share.constants.dart';
import '../use_case/import/import_chan.use_case.dart';
import '../use_case/import/import_roles.use_case.dart';
import '../utils/key.util.dart';
import '../utils/printer.util.dart';
import 'package:logger/logger.dart' as logger;

///
/// IMPORT COMMAND
///
final importCommand = ChatCommand(
  'import',
  'Start import process',
  options: CommandOptions(
    autoAcknowledgeInteractions: true,
    acceptSelfCommands: true,
    autoAcknowledgeDuration: Duration(days: 1),
  ),
  id('import', (
    InteractionChatContext context,
    @Description('Identifiant du serveur à importer')
    @Name('id')
    String serverIdToImport,
    @Description('Clé privée permettant de déchiffrer la sauvegarde')
    @Name('privateKey')
    String privateKey,
  ) async {
    final int serverId = context.guild?.id.value ?? -1;

    LoggerService(serverId).writeLog(
      logger.Level.info,
      "🚴‍♂️ Démarrage du processus d'import ",
    );

    if (((await context.guild?.fetchChannels())?.length ?? 0) > 4) {
      await writeMessage(
        context,
        "** ❌ Vous ne pouvez pas importer un serveur si celui-ci possède déjà de nombreux channels. Afin d'éviter d'importer un serveur sur un serveur existant. (Nombre de channels maximum autorisé : 4)  **",
      );
      return;
    }

    final int? parsedArg = int.tryParse(serverIdToImport);
    if (parsedArg == null) {
      await writeMessage(
        context,
        "** ❌ L'ID du serveur doit être un chiffre au format 123456789... **",
      );
      return;
    }

    RSAPrivateKey pK;

    try {
      pK = RSAKeyParser().parse(formatPrivatePem(privateKey)) as RSAPrivateKey;
    } catch (e) {
      LoggerService(serverId).writeLog(
        logger.Level.error,
        "❌ Clé privée RSA au mauvais format ($privateKey)",
      );
      await writeMessage(
        context,
        "❌ La clé privée RSA ne possède pas le bon format, vérifiez la ou regénérez la.",
      );
      return;
    }

    await writeMessage(
      context,
      "🚴‍♂️ Démarrage du processus d'import...",
    );

    final Export? lastSave = await DatabaseService().fetchDocument(
      saveCollectionKey,
      serverIdKey,
      parsedArg,
      Export.fromJson,
    );

    if (lastSave == null) {
      await writeMessage(
        context,
        "** ❌ Impossible de récupérer la dernière sauvegarde (sauvegarde inexistante) **",
      );
      return;
    }

    final Encrypter rsaDecrypter = Encrypter(RSA(privateKey: pK));
    final Encrypted encryptedAesKey =
        Encrypted.fromBase64(lastSave.encryptedAesKey);

    final String aesKeyBase64 = rsaDecrypter.decrypt(encryptedAesKey);
    final Key decryptedAesKey = Key.fromBase64(aesKeyBase64);

    final Encrypter aesDecrypter = Encrypter(
      AES(
        decryptedAesKey,
        mode: AESMode.cbc,
      ),
    );
    final Encrypted encryptedData = Encrypted.fromBase64(lastSave.serverSave);

    final String decryptedData = aesDecrypter.decrypt(
      encryptedData,
      iv: IV.fromBase64(
        lastSave.iv,
      ),
    );

    final List<int> decodedServer = gzip.decode(
      base64.decode(decryptedData),
    );
    final Map<String, dynamic> json = jsonDecode(
      utf8.decode(decodedServer),
    );

    final GuildExport guildExport = GuildExport.fromJson(json);

    final Map<int, int>? importedRoles = await ImportRolesUseCase.importRoles(
      guildExport.roles,
      context,
    );

    ImportChanUseCase(importedRoles: importedRoles).importChanAndMessage(
      guildExport.chans,
      context,
    );

    await writeMessage(
      context,
      "**✅ Import terminé **",
    );
  }),
);
