import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

import '../../entity/custom_chan.dart';
import '../../entity/message.entity.dart';
import '../../exceptions/exceptions.dart';
import '../../service/logger.service.dart';
import 'package:logger/logger.dart' as logger;

///
/// [ImportChanUseCase]
///
class ImportChanUseCase {
  /// Imported roles
  final Map<int, int>? importedRoles;

  ///
  /// Constructor
  ///
  ImportChanUseCase({
    required this.importedRoles,
  });

  ///
  /// Import channels and messages
  ///
  Future<void> importChanAndMessage(
    List<CustomChan>? channels,
    ChatContext context,
  ) async {
    if (importedRoles == null || channels == null) return;
    Map<int, int> importedCategories = {};

    for (final CustomChan customChan in channels) {
      final ChannelType chanType = ChannelType.parse(customChan.channelType);

      final List<PermissionOverwriteBuilder> permissionOverwrite =
          customChan.perm.map((customPerm) {
        final int id =
            importedRoles![customPerm.snowflakeId] ?? customPerm.snowflakeId;

        return PermissionOverwriteBuilder(
          id: customPerm.isEveryone ? context.guild!.id : Snowflake.parse(id),
          type: PermissionOverwriteType.parse(customPerm.permType),
          allow: Permissions(customPerm.allowValue),
          deny: customPerm.isEveryone
              ? Permissions.viewChannel
              : Permissions(customPerm.denyValue),
        );
      }).toList();

      if (chanType == ChannelType.guildText) {
        try {
          _buildTextChannel(
            customChan,
            context,
            permissionOverwrite,
            importedCategories,
          );
        } on Exception catch (e) {
          LoggerService(context.guild?.id.value ?? -1).writeLog(
            logger.Level.error,
            "❌ Une erreur s'est produite lors de la création d'un canal écrit: $e (${customChan.channelName})",
          );

          throw BuildChannelException(e.toString());
        }
      } else if (chanType == ChannelType.guildCategory) {
        try {
          final GuildCategory? createdCat = await _buildCat(
            customChan,
            context,
            permissionOverwrite,
          );

          importedCategories[customChan.id] = createdCat!.id.value;
        } on Exception catch (e) {
          LoggerService(context.guild?.id.value ?? -1).writeLog(
            logger.Level.error,
            "❌ Une erreur s'est produite lors de la création d'une catégorie: $e (${customChan.channelName})",
          );

          throw BuildCategoryException(e.toString());
        }
      }
    }
  }

  ///
  /// Build categories (containing text / voice channels)
  ///
  Future<GuildCategory?> _buildCat(
    CustomChan customChan,
    ChatContext context,
    List<PermissionOverwriteBuilder> permissionOverwrite,
  ) async {
    return await context.guild?.createChannel(
      GuildCategoryBuilder(
        name: customChan.channelName,
        position: customChan.position,
        permissionOverwrites: permissionOverwrite,
      ),
    );
  }

  ///
  /// Build text channels
  ///
  static Future<void> _buildTextChannel(
    CustomChan customChan,
    ChatContext context,
    List<PermissionOverwriteBuilder> permissionOverwrite,
    Map<int, int> importedCategories,
  ) async {
    final channel = await context.guild?.createChannel(
      GuildTextChannelBuilder(
        name: customChan.channelName,
        position: customChan.position,
        parentId: customChan.parentId != null &&
                importedCategories.containsKey(customChan.parentId)
            ? Snowflake(importedCategories[customChan.parentId!]!)
            : null,
        permissionOverwrites: permissionOverwrite,
      ),
    );

    if (customChan.userMessage == null) return;
    for (final UserMessage message in customChan.userMessage!) {
      try {
        await (channel as TextChannel).sendMessage(
          MessageBuilder(content: "$message"),
        );
      } catch (error) {
        continue;
      }
    }
  }
}
