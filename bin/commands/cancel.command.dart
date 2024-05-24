import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:logger/logger.dart' as logger;
import '../service/core.service.dart';
import '../service/logger.service.dart';
import '../utils/printer.util.dart';

///
/// CANCEL COMMAND
///
final cancelCommand = ChatCommand(
  'cancel',
  'Stop auto backup process',
  options: CommandOptions(
    autoAcknowledgeInteractions: true,
    acceptSelfCommands: true,
    autoAcknowledgeDuration: Duration(days: 1),
  ),
  id('cancel', (InteractionChatContext context) async {
    if (!(await CoreService().isInWhiteList(context.user.id.value))) {
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

    final int serverId = context.guild?.id.value ?? -1;

    LoggerService(serverId).writeLog(
      logger.Level.info,
      "🚔 Arrêt des services, le back up automatique ne sera plus effectué.",
    );

    try {
      await CoreService().stopServices(serverId);

      writeMessage(
        context,
        '😔 Arrêt des services, le back up automatique ne sera plus effectué. Vos sauvegardes restent conservées sans limite de temps.',
      );
    } on Exception catch (e) {
      writeMessage(
        context,
        "La sauvegarde automatique n'a pas pu être arrêté dû à une erreur ($e)",
      );

      LoggerService(serverId).writeLog(
        logger.Level.info,
        "❌ Erreur lors de l'arrêt du bot ($e)",
      );
    }
  }),
);
