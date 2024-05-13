// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMessage _$UserMessageFromJson(Map<String, dynamic> json) => UserMessage(
      content: json['content'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      author: json['author'] as String?,
      thread: json['thread'] == null
          ? null
          : CustomThread.fromJson(json['thread'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserMessageToJson(UserMessage instance) =>
    <String, dynamic>{
      'content': instance.content,
      'timestamp': instance.timestamp?.toIso8601String(),
      'author': instance.author,
      'thread': instance.thread?.toJson(),
    };
