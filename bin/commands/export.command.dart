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
      ChatContext context,
      @Description("Clé publique RSA permettant le chiffrement des données")
      String publicKey, [
      @UseConverter(parameterTypeConverter)
      @Description("Paramètre optionnel à ajouter pour l'export")
      Parameters parameters = Parameters.noParameter,
    ]) async {
      await ExportService(
        context.guild?.id.value ?? -1,
        context.channel.id.value,
        publicKey: publicKey,
      ).processExport(parameters);
    },
  ),
);
