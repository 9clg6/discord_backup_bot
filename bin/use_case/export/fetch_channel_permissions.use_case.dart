import 'package:nyxx/nyxx.dart';

import '../../entity/custom_chan_perm.dart';
import '../../service/logger.service.dart';
import 'package:logger/logger.dart' as logger;

///
/// [FetchChannelPermissionsUseCase]
///
class FetchChannelPermissionsUseCase {
  ///
  /// Fetch channels permissions
  ///
  static List<CustomChanPerm> fetchChanPermission(
    GuildChannel chan,
    int guildId,
  ) {
    LoggerService(guildId).writeLog(
      logger.Level.info,
      "👮 Récupération des permissions du canal ${chan.name}",
      save: false,
    );

    List<CustomChanPerm> chanPerm = [];

    for (final PermissionOverwrite permOverwrite in chan.permissionOverwrites) {
      chanPerm.add(
        CustomChanPerm(
          allowValue: permOverwrite.allow.value,
          denyValue: permOverwrite.deny.value,
          permType: permOverwrite.type.value,
          snowflakeId: permOverwrite.id.value,
          isEveryone: permOverwrite.id.value == chan.guild.id.value,
        ),
      );
    }

    LoggerService(guildId).writeLog(
      logger.Level.info,
      "👮✅ Récupération des permissions du canal ${chan.name} OK",
      save: false,
    );

    return chanPerm;
  }
}
