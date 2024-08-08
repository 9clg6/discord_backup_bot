import 'package:nyxx/nyxx.dart';

import '../../entity/custom_chan.dart';
import '../../entity/custom_chan_perm.dart';
import '../../entity/message.entity.dart';
import '../../service/logger.service.dart';
import 'fetch_channel_permissions.use_case.dart';
import 'fetch_all_messages_from_channel.use_case.dart';
import 'package:logger/logger.dart' as logger;

///
/// [FetchChannelsUseCase]
///
class FetchChannelsUseCase {
  ///
  /// Fetch channels from the given [guild]
  /// [noMessageSave] permits to avoid message save
  ///
  static Future<List<CustomChan>> fetchChans(
    PartialGuild guild, {
    bool noMessageSave = false,
  }) async {
    LoggerService(
      guild.id.value,
    ).writeLog(
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

      LoggerService(
        guild.id.value,
      ).writeLog(
        logger.Level.info,
        print: false,
        "📑 Récupération des permissions de channels (${guildChan.name})",
      );

      List<CustomChanPerm> permissions =
          FetchChannelPermissionsUseCase.fetchChanPermission(
        guildChan,
        guild.id.value,
      );

      LoggerService(
        guild.id.value,
      ).writeLog(
        logger.Level.info,
        print: false,
        "📑✅ Récupération des permissions de channels OK",
      );

      if (guildChan.type == ChannelType.guildText && !noMessageSave) {
        LoggerService(
          guild.id.value,
        ).writeLog(
          logger.Level.info,
          print: false,
          "📑 Récupération des messages du channel (${guildChan.name})",
        );
        messages = await FetchAllMessagesFromChannelUseCase.execute(
          guildChan,
          guild.id.value,
        );

        LoggerService(
          guild.id.value,
        ).writeLog(
          logger.Level.info,
          print: false,
          "📑✅ Récupération des messages du channel OK",
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

    LoggerService(
      guild.id.value,
    ).writeLog(
      logger.Level.info,
      print: false,
      "📑✅ Channels récupérés",
    );

    return exportedChans.whereType<CustomChan>().toList()
      ..sort((a, b) => a.position.compareTo(b.position));
  }
}
