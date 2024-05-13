import 'package:nyxx_commands/nyxx_commands.dart';

import '../exceptions/exceptions.dart';
import '../service/core.service.dart';
import '../use_case/enum/parameters.enum.dart';
import '../utils/printer.util.dart';

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
      ChatContext context, [
      @UseConverter(parameterTypeConverter)
      @Description("Paramètre optionnel à ajouter pour l'export")
      Parameters? parameters,
    ]) async {
      final int? guildId = context.guild?.id.value;
      if (guildId == null) return;

      if (await CoreService().isInitialized(guildId)) {
        await writeMessage(context, "❌ Le bot a déjà été initialisé");
        return;
      }

      try {
        await CoreService().initialize(
          guildId,
          context.channel.id.value,
          parameters?.code,
        );
      } on InitializationResult catch (e) {
        await writeMessage(context, e.cause);
        return;
      }

      CoreService().startCron(
        parameters ?? Parameters.noParameter,
        context.guild?.id.value ?? -1,
        context.channel.id.value,
      );

      await writeMessage(
        context,
        "**⏰ La sauvegarde du serveur est désormais programmé pour s'effectuer une fois par jour.**",
      );
    },
  ),
);
