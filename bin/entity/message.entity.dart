import 'package:json_annotation/json_annotation.dart';
import 'package:nyxx/nyxx.dart';

import '../mixin/serializable.mixin.dart';
import 'custom_thread.dart';

part 'message.entity.g.dart';

///
/// [UserMessage]
///
@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class UserMessage with SerializableMixin {
  String? content;
  DateTime? timestamp;
  String? author;
  CustomThread? thread;

  UserMessage({
    this.content,
    this.timestamp,
    this.author,
    this.thread,
  });

  factory UserMessage.fromMessage({
    required Message m,
    CustomThread? thread,
  }) {
    return UserMessage(
      author: m.author.username,
      content: m.content,
      timestamp: m.timestamp,
      thread: thread,
    );
  }

  @override
  String toString() {
    return "**[${timestamp?.day}/${timestamp?.month}/${timestamp?.year} - ${timestamp?.hour}:${timestamp?.minute}:${timestamp?.second}] $author:** $content";
  }

  @override
  Map<String, dynamic> toJson() => _$UserMessageToJson(this);

  factory UserMessage.fromJson(Map<String, dynamic> json) =>
      _$UserMessageFromJson(json);
}
