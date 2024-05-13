// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_chan_perm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomChanPerm _$CustomChanPermFromJson(Map<String, dynamic> json) =>
    CustomChanPerm(
      allowValue: (json['allow_value'] as num).toInt(),
      denyValue: (json['deny_value'] as num).toInt(),
      permType: (json['perm_type'] as num).toInt(),
      snowflakeId: (json['snowflake_id'] as num).toInt(),
      isEveryone: json['is_everyone'] as bool? ?? false,
    );

Map<String, dynamic> _$CustomChanPermToJson(CustomChanPerm instance) =>
    <String, dynamic>{
      'allow_value': instance.allowValue,
      'deny_value': instance.denyValue,
      'perm_type': instance.permType,
      'snowflake_id': instance.snowflakeId,
      'is_everyone': instance.isEveryone,
    };
