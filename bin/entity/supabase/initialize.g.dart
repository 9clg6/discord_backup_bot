// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initialize.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Initialize _$InitializeFromJson(Map<String, dynamic> json) => Initialize(
      id: (json['id'] as num).toInt(),
      channelId: (json['channel_id'] as num).toInt(),
      code: (json['code'] as num).toInt(),
      initValue: json['init_value'] as bool,
      publicKey: json['public_key'] as String,
    );

Map<String, dynamic> _$InitializeToJson(Initialize instance) =>
    <String, dynamic>{
      'id': instance.id,
      'channel_id': instance.channelId,
      'code': instance.code,
      'init_value': instance.initValue,
      'public_key': instance.publicKey,
    };
