import 'package:dotenv/dotenv.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:supabase/supabase.dart';
import 'commands/export.command.dart';
import 'commands/import.command.dart';
import 'commands/initialize.command.dart';
import 'service/core.service.dart';
import 'share/share.constants.dart';

///
/// Entrypoint
///
Future<void> main(List<String> arguments) async {
  final env = DotEnv(includePlatformEnvironment: true)..load();

  supabase = SupabaseClient(
    env[supabaseDatabaseAddress] ?? '',
    env[supabaseApiKeyKey] ?? '',
  );

  CommandsPlugin commands = initializeCommands();

  client = await Nyxx.connectGateway(
    env[discordApiKeyKey] ?? '',
    GatewayIntents.allPrivileged,
    options: GatewayClientOptions(
      plugins: [
        commands,
        logging,
        cliIntegration,
        ignoreExceptions,
      ],
    ),
  );

  client.onReady.listen((ReadyEvent readyEvent) async {
    await CoreService().initializeAtStart(client);

    print('-----Ready-----');
  });
}

///
/// Initialize Commands
///
CommandsPlugin initializeCommands() {
  return CommandsPlugin(
    prefix: (_) => '/',
    options: CommandsOptions(
      logErrors: true,
    ),
  )
    ..addCommand(initializeCommand)
    ..addCommand(exportCommand)
    ..addCommand(importCommand);
}
