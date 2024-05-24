import 'package:nyxx_commands/nyxx_commands.dart';

import '../service/core.service.dart';
import '../service/export.service.dart';
import '../service/logger.service.dart';
import '../use_case/enum/parameters.enum.dart';
import '../utils/printer.util.dart';
import 'package:logger/logger.dart' as logger;

///
/// EXPORT COMMAND
///
final exportCommand = ChatCommand(
  'export',
  'Start channel export process',
  options: CommandOptions(
    autoAcknowledgeInteractions: true,
    acceptSelfCommands: true,
    autoAcknowledgeDuration: Duration(days: 1),
  ),
  id(
    'export',
    (
      ChatContext context,
      @Description("Clé publique RSA permettant le chiffrement des données")
      String publicKey, [
      @UseConverter(parameterTypeConverter)
      @Description("Paramètre optionnel à ajouter pour l'export")
      Parameters parameters = Parameters.noParameter,
    ]) async {
      if (!await CoreService().isInWhiteList(context.user.id.value)) {
        writeMessage(
          context,
          "🚨 Vous n'êtes pas présent dans la white-list 🚨",
        );

        LoggerService(context.guild!.id.value).writeLog(
          logger.Level.info,
          "🚨🚨 UTILISATEUR NON WHITE-LISTE (serveur: ${context.guild?.name} ): \n id: ${context.user.id.value} \n globalName: ${context.user.globalName} \n username: ${context.user.username} 🚨🚨",
        );
        return;
      }

      await ExportService(
        context.guild?.id.value ?? -1,
        context.channel.id.value,
        publicKey: publicKey,
      ).processExport(parameters);
    },
  ),
);
