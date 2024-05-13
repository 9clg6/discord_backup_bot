// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_chan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomChan _$CustomChanFromJson(Map<String, dynamic> json) => CustomChan(
      position: (json['position'] as num).toInt(),
      channelType: (json['channel_type'] as num).toInt(),
      channelName: json['channel_name'] as String,
      userMessage: (json['user_message'] as List<dynamic>?)
          ?.map((e) => UserMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      parentId: (json['parent_id'] as num?)?.toInt(),
      id: (json['id'] as num).toInt(),
      perm: (json['perm'] as List<dynamic>)
          .map((e) => CustomChanPerm.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomChanToJson(CustomChan instance) =>
    <String, dynamic>{
      'position': instance.position,
      'channel_type': instance.channelType,
      'channel_name': instance.channelName,
      'parent_id': instance.parentId,
      'user_message': instance.userMessage?.map((e) => e.toJson()).toList(),
      'perm': instance.perm.map((e) => e.toJson()).toList(),
      'id': instance.id,
    };
