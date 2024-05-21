// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Export _$ExportFromJson(Map<String, dynamic> json) => Export(
      (json['id'] as num).toInt(),
      json['serverName'] as String,
      (json['serverId'] as num).toInt(),
      json['encryptedAes'] as String,
      json['iv'] as String,
      json['server'] as String,
    );

Map<String, dynamic> _$ExportToJson(Export instance) => <String, dynamic>{
      'server': instance.serverSave,
      'serverName': instance.serverName,
      'id': instance.id,
      'serverId': instance.serverId,
      'encryptedAes': instance.encryptedAesKey,
      'iv': instance.iv,
    };
