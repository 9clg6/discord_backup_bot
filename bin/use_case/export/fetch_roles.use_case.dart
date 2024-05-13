import 'package:nyxx/nyxx.dart';

import '../../entity/custom_role.entity.dart';
import '../../exceptions/exceptions.dart';
import 'package:logger/logger.dart' as logger;

import '../../service/logger.service.dart';

///
/// [FetchRolesUseCase]
///
class FetchRolesUseCase {
  ///
  /// Fetch existing roles in the [guild]
  ///
  static Future<List<CustomRole>>? fetchRoles(PartialGuild guild) async {
    LoggerService(guild.id.value).writeLog(
      logger.Level.info,
      "💼 Récupération des rôles",
    );

    List<CustomRole> roles = [];

    try {
      final rolesRoles = await guild.roles.list();

      for (final Role role in rolesRoles) {
        if (role.name == "Dibo") continue;

        roles.add(
          CustomRole(
            color: CustomRoleColor(
              role.color.r,
              role.color.g,
              role.color.b,
            ),
            iconHash: role.iconHash,
            isHoisted: role.isHoisted,
            isMentionable: role.isMentionable,
            name: role.name,
            permissionValue: role.permissions.value,
            rolePosition: role.position,
            id: role.id.value,
          ),
        );
      }
    } on Exception catch (e) {
      LoggerService(guild.id.value).writeLog(
        logger.Level.error,
        "❌ Une erreur s'est produite lors de la récupération des rôles: $e",
      );

      throw FetchRolesException(e.toString());
    }

    LoggerService(guild.id.value).writeLog(
      logger.Level.info,
      "💼✅ Récupération des rôles OK",
    );

    return roles.reversed.toList();
  }
}
