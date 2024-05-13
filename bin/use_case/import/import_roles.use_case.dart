import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

import '../../entity/custom_role.entity.dart';
import '../../exceptions/exceptions.dart';
import '../../service/logger.service.dart';
import 'package:logger/logger.dart' as logger;

///
/// [ImportRolesUseCase]
///
class ImportRolesUseCase {
  ///
  /// Import roles
  ///
  static Future<Map<int, int>?> importRoles(
    List<CustomRole>? roles,
    ChatContext context,
  ) async {
    if (roles == null) return null;
    Map<int, int> roleMap = {};

    for (final CustomRole importedRole in roles) {
      if (importedRole.name == "@everyone") {
        final Role? everyoneRole = (await context.guild?.roles.list())
            ?.firstWhere((r) => r.name == '@everyone');

        if (everyoneRole == null) continue;

        try {
          await context.guild?.roles.update(
            everyoneRole.id,
            RoleUpdateBuilder(
              permissions: Permissions(importedRole.permissionValue!),
            ),
          );

          roleMap[importedRole.id!] = everyoneRole.id.value;
        } on Exception catch (e) {
          LoggerService(context.guild?.id.value ?? -1).writeLog(
            logger.Level.error,
            '❌ Impossible de mettre à jour le rôle @everyone (${e.toString()})',
          );
        }
      } else {
        try {
          final Role? createdRole = await context.guild?.roles.create(
            RoleBuilder(
              color: DiscordColor.fromRgb(
                importedRole.color?.r ?? 0,
                importedRole.color?.g ?? 0,
                importedRole.color?.b ?? 0,
              ),
              isHoisted: importedRole.isHoisted,
              isMentionable: importedRole.isMentionable,
              name: importedRole.name,
              permissions: Flags<Permissions>(importedRole.permissionValue!),
            ),
          );

          roleMap[importedRole.id!] = createdRole!.id.value;
        } on Exception catch (e) {
          LoggerService(context.guild?.id.value ?? -1).writeLog(
            logger.Level.error,
            "❌ Une erreur s'est produite lors de la création d'un role: $e (${importedRole.name})",
          );

          throw CreateRoleException(e.toString());
        }
      }
    }

    return roleMap;
  }
}
