// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initialize.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Initialize _$InitializeFromJson(Map<String, dynamic> json) => Initialize(
      serverId: (json['serverId'] as num).toInt(),
      channelId: (json['channelId'] as num).toInt(),
      parameter: (json['parameter'] as num).toInt(),
      isInitialized: json['isInitialized'] as bool,
      publicKey: json['publicKey'] as String,
    );

Map<String, dynamic> _$InitializeToJson(Initialize instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'channelId': instance.channelId,
      'parameter': instance.parameter,
      'isInitialized': instance.isInitialized,
      'publicKey': instance.publicKey,
    };
