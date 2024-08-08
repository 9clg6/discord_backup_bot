// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_log_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangeLogState _$ChangeLogStateFromJson(Map<String, dynamic> json) =>
    ChangeLogState(
      (json['id'] as num).toInt(),
      json['lastChangelogVersionRed'] as String,
    );

Map<String, dynamic> _$ChangeLogStateToJson(ChangeLogState instance) =>
    <String, dynamic>{
      'id': instance.serverId,
      'lastChangelogVersionRed': instance.version,
    };
