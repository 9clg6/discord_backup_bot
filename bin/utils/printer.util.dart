import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

import '../service/logger.service.dart';
import '../share/share.constants.dart';
import 'package:logger/logger.dart' as logger;

///
/// Write message in discord chat
///
Future<void> writeMessage(ChatContext context, String message) async {
  try {
    await context.respond(
      MessageBuilder(content: message),
    );
  } on Exception catch (e) {
    LoggerService(context.guild?.id.value ?? -1).writeLog(
      logger.Level.error,
      '💢 PRINTER ERROR ($e)',
    );
  }
}

///
/// Write message in discord chat
///
Future<void> writeMessageWithChannelId(
  int chanId,
  int serverId,
  String message,
) async {
  try {
    final PartialTextChannel channel = (await client.channels
        .get(Snowflake.parse(chanId))) as PartialTextChannel;

    await channel.sendMessage(MessageBuilder(content: message));
  } on Exception catch (e) {
    LoggerService(serverId).writeLog(
      logger.Level.error,
      '💢 PRINTER ERROR ($e)',
    );
  }
}
