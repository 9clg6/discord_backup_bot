// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_thread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomThread _$CustomThreadFromJson(Map<String, dynamic> json) => CustomThread(
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      name: json['name'] as String?,
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => UserMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomThreadToJson(CustomThread instance) =>
    <String, dynamic>{
      'created_at': instance.createdAt?.toIso8601String(),
      'messages': instance.messages?.map((e) => e.toJson()).toList(),
      'name': instance.name,
    };
