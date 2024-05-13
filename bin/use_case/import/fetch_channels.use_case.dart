import 'package:nyxx/nyxx.dart';

import '../../entity/custom_chan.dart';
import '../../entity/custom_chan_perm.dart';
import '../../entity/message.entity.dart';
import '../../service/logger.service.dart';
import '../export/fetch_all_messages_from_channel.use_case.dart';
import '../export/fetch_channel_permissions.use_case.dart';
import 'package:logger/logger.dart' as logger;

///
/// [FetchChannelsUseCase]
///
class FetchChannelsUseCase {
  ///
  /// Fetch channels
  ///
  static Future<List<CustomChan>> fetchChans(PartialGuild guild) async {
    LoggerService(guild.id.value).writeLog(
      logger.Level.info,
      "📑 Récupération des channels",
    );

    final List<GuildChannel> channels = await guild.fetchChannels();

    // Récupération des permissions et des messages de manière parallèle pour chaque channel
    final List<Future<CustomChan?>> futures = channels.map((guildChan) async {
      if (guildChan.id.value == 1131570099711651971 ||
          guildChan.id.value == 1131570154157920347) {
        return null;
      }

      List<UserMessage>? messages;
      List<CustomChanPerm> permissions =
          FetchChannelPermissionsUseCase.fetchChanPermission(
        guildChan,
        guild.id.value,
      );

      if (guildChan.type == ChannelType.guildText) {
        messages = await FetchAllMessagesFromChannelUseCase.execute(
          guildChan,
          guild.id.value,
        );
      }

      return CustomChan(
        position: guildChan.position,
        channelType: guildChan.type.value,
        channelName: guildChan.name,
        parentId: guildChan.parentId?.value != guildChan.guildId.value
            ? guildChan.parentId?.value
            : null,
        userMessage: messages,
        id: guildChan.id.value,
        perm: permissions,
      );
    }).toList();

    final List<CustomChan?> exportedChans = await Future.wait(futures);
    return exportedChans.whereType<CustomChan>().toList()
      ..sort((a, b) => a.position.compareTo(b.position));
  }
}
