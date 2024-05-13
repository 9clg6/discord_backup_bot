import 'dart:convert';
import 'dart:io';

import 'package:nyxx_commands/nyxx_commands.dart';

import '../entity/guild_export.entity.dart';
import '../service/logger.service.dart';
import '../share/share.constants.dart';
import '../use_case/import/import_chan.use_case.dart';
import '../use_case/import/import_roles.use_case.dart';
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
  ) async {
    LoggerService(context.guild?.id.value ?? -1).writeLog(
      logger.Level.info,
      "🚴‍♂️ [${DateTime.now().toIso8601String()}] Démarrage du processus d'import ",
    );

    await writeMessage(
      context,
      "🚴‍♂️ Démarrage du processus d'import...",
    );

    final int? parsedArg = int.tryParse(serverIdToImport);
    if (parsedArg == null) {
      await writeMessage(
        context,
        "** ❌ L'ID du serveur doit être un chiffre au format 123456789... **",
      );
      return;
    }

    final List<Map<String, dynamic>> lastDoc = await supabase
        .from(saveCollectionKey)
        .select()
        .eq('serverId', parsedArg);

    if (lastDoc.isEmpty) {
      await writeMessage(
        context,
        "** ❌ Impossible de récupérer la dernière sauvegarde (sauvegarde inexistante) **",
      );
      return;
    }

    final Map<String, dynamic> lastSave = lastDoc.first;

    List<int> decodedServer = gzip.decode(base64.decode(lastSave['server']));
    Map<String, dynamic> jsonServer = jsonDecode(utf8.decode(decodedServer));

    final GuildExport guildExport = GuildExport.fromJson(jsonServer);

    //Clé : ID Rôle importé, Valeur: ID créé sur ce serveur
    final Map<int, int>? importedRoles =
        await ImportRolesUseCase.importRoles(guildExport.roles, context);

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
