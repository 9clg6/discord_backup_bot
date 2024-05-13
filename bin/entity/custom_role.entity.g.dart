// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_role.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomRole _$CustomRoleFromJson(Map<String, dynamic> json) => CustomRole(
      color: json['color'] == null
          ? null
          : CustomRoleColor.fromJson(json['color'] as Map<String, dynamic>),
      id: (json['id'] as num?)?.toInt(),
      iconHash: json['icon_hash'] as String?,
      isHoisted: json['is_hoisted'] as bool?,
      isMentionable: json['is_mentionable'] as bool?,
      name: json['name'] as String?,
      permissionValue: (json['permission_value'] as num?)?.toInt(),
      rolePosition: (json['role_position'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CustomRoleToJson(CustomRole instance) =>
    <String, dynamic>{
      'icon_hash': instance.iconHash,
      'name': instance.name,
      'permission_value': instance.permissionValue,
      'is_hoisted': instance.isHoisted,
      'is_mentionable': instance.isMentionable,
      'role_position': instance.rolePosition,
      'id': instance.id,
      'color': instance.color?.toJson(),
    };

CustomRoleColor _$CustomRoleColorFromJson(Map<String, dynamic> json) =>
    CustomRoleColor(
      (json['r'] as num).toInt(),
      (json['g'] as num).toInt(),
      (json['b'] as num).toInt(),
    );

Map<String, dynamic> _$CustomRoleColorToJson(CustomRoleColor instance) =>
    <String, dynamic>{
      'r': instance.r,
      'g': instance.g,
      'b': instance.b,
    };
