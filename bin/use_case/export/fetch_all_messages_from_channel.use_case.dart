import 'package:nyxx/nyxx.dart';
import 'package:nyxx_extensions/nyxx_extensions.dart';

import '../../entity/custom_thread.dart';
import '../../entity/message.entity.dart';
import '../../service/logger.service.dart';
import 'package:logger/logger.dart' as logger;

///
/// [FetchAllMessagesFromChannelUseCase]
///
class FetchAllMessagesFromChannelUseCase {
  ///
  /// Fetch all messages from the given [channel]
  ///
  static Future<List<UserMessage>> execute(
    GuildChannel channel,
    int guildId,
  ) async {
    LoggerService(guildId).writeLog(
      logger.Level.info,
      "📱 Récupération des message du canal ${channel.name}...",
      save: false,
    );

    final messages = (await (channel as TextChannel)
        .messages
        .stream(order: StreamOrder.oldestFirst)
        .asyncMap((Message m) async {
      final List<UserMessage>? threadMessages = (await m.thread?.messages
          .stream()
          .where((message) => message.content.isNotEmpty)
          .map((m) => UserMessage.fromMessage(m: m))
          .toList());

      return UserMessage.fromMessage(
        m: m,
        thread: threadMessages != null && threadMessages.isNotEmpty
            ? CustomThread.fromThread(
                m.thread,
                threadMessages,
              )
            : null,
      );
    }).toList());

    LoggerService(guildId).writeLog(
      logger.Level.info,
      "📱✅ Récupération des message du canal ${channel.name} OK",
      save: false,
    );

    return messages;
  }
}
