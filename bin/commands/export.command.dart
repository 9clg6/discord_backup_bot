import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

import '../service/export.service.dart';
import '../use_case/enum/parameters.enum.dart';

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
      ChatContext context, [
      @UseConverter(parameterTypeConverter)
      @Description("Paramètres optionnels à ajouter pour l'export")
      Parameters? parameters,
    ]) async {
      parameters ??= await context.getSelection<Parameters>(
        Parameters.values,
        authorOnly: true,
        MessageBuilder(
          content: "Sélectionnes les paramètres OPTIONNELS d'export",
        ),
      );

      await ExportService(
        context.guild?.id.value ?? -1,
        context.channel.id.value,
      ).processExport(parameters);
    },
  ),
);
