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
