// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guild_export.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuildExport _$GuildExportFromJson(Map<String, dynamic> json) => GuildExport(
      guildName: json['guild_name'] as String?,
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => CustomRole.fromJson(e as Map<String, dynamic>))
          .toList(),
      chans: (json['chans'] as List<dynamic>?)
          ?.map((e) => CustomChan.fromJson(e as Map<String, dynamic>))
          .toList(),
      guildId: (json['guild_id'] as num).toInt(),
    )..timestamp = (json['timestamp'] as num?)?.toInt();

Map<String, dynamic> _$GuildExportToJson(GuildExport instance) =>
    <String, dynamic>{
      'guild_name': instance.guildName,
      'roles': instance.roles?.map((e) => e.toJson()).toList(),
      'chans': instance.chans?.map((e) => e.toJson()).toList(),
      'guild_id': instance.guildId,
      'timestamp': instance.timestamp,
    };
