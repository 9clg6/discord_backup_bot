import 'package:json_annotation/json_annotation.dart';
import '../mixin/serializable.mixin.dart';

part 'custom_role.entity.g.dart';

///
/// [CustomRole]
///
@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class CustomRole with SerializableMixin {
  final String? iconHash;
  final String? name;
  final int? permissionValue;
  final bool? isHoisted;
  final bool? isMentionable;
  final int? rolePosition;
  final int? id;
  final CustomRoleColor? color;

  CustomRole({
    this.color,
    this.id,
    this.iconHash,
    this.isHoisted,
    this.isMentionable,
    this.name,
    this.permissionValue,
    this.rolePosition,
  });

  @override
  Map<String, dynamic> toJson() => _$CustomRoleToJson(this);

  factory CustomRole.fromJson(Map<String, dynamic> json) =>
      _$CustomRoleFromJson(json);

  @override
  String toString() {
    return 'Name: $name, Icon $iconHash, PermissionValue: $permissionValue, isHoisted: $isHoisted, isMentionable: $isMentionable, Role position: $rolePosition, Color: $color';
  }
}

///
/// [CustomRoleColor]
///
@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class CustomRoleColor with SerializableMixin {
  final int r;
  final int g;
  final int b;

  CustomRoleColor(
    this.r,
    this.g,
    this.b,
  );

  @override
  Map<String, dynamic> toJson() => _$CustomRoleColorToJson(this);

  factory CustomRoleColor.fromJson(Map<String, dynamic> json) =>
      _$CustomRoleColorFromJson(json);

  @override
  String toString() {
    return 'rgb($r, $g, $b)';
  }
}
