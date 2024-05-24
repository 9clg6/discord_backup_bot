import 'package:encrypt/encrypt.dart';
import "package:nyxx_commands/nyxx_commands.dart";
import 'package:pointycastle/pointycastle.dart';
import '../exceptions/exceptions.dart';
import '../service/core.service.dart';
import '../service/logger.service.dart';
import '../use_case/enum/parameters.enum.dart';
import '../utils/key.util.dart';
import '../utils/printer.util.dart';
import 'package:logger/logger.dart' as logger;

///
/// INITIALISE COMMAND
///
final ChatCommand initializeCommand = ChatCommand(
  'initialize',
  'Initialiser le bot de sauvegarde',
  options: CommandOptions(
    autoAcknowledgeInteractions: true,
    acceptSelfCommands: false,
    autoAcknowledgeDuration: Duration(days: 1),
  ),
  id(
    'initialize',
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

      final int? guildId = context.guild?.id.value;
      if (guildId == null) return;

      if (await CoreService().isInitialized(guildId)) {
        await writeMessage(context, "❌ Le bot a déjà été initialisé");
        return;
      }

      try {
        RSAKeyParser().parse(formatPublicPem(publicKey)) as RSAPublicKey;
      } catch (e) {
        LoggerService(guildId).writeLog(
          logger.Level.error,
          "❌ Clé public RSA au mauvais format ($publicKey)",
        );
        await writeMessage(
          context,
          "❌ La clé public RSA ne possède pas le bon format, vérifiez la ou regénérez la.",
        );
        return;
      }

      try {
        await CoreService().initialize(
          guildId,
          publicKey: publicKey,
          channelId: context.channel.id.value,
          code: parameters.code,
        );
      } on InitializationException catch (e) {
        await writeMessage(context, e.cause);
        return;
      }

      CoreService().startCron(
        parameters,
        context.guild?.id.value ?? -1,
        context.channel.id.value,
        publicKey: publicKey,
      );

      await writeMessage(
        context,
        "**⏰ La sauvegarde du serveur est désormais programmé pour s'effectuer une fois par jour.**",
      );
    },
  ),
);
