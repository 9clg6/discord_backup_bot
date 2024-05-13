import 'package:json_annotation/json_annotation.dart';
import 'package:nyxx/nyxx.dart';

import '../mixin/serializable.mixin.dart';
import 'message.entity.dart';

part 'custom_thread.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class CustomThread with SerializableMixin {
  final DateTime? createdAt;

  final List<UserMessage>? messages;

  final String? name;

  CustomThread({
    this.createdAt,
    this.name,
    this.messages,
  });

  factory CustomThread.fromThread(
    Thread? thread, [
    List<UserMessage>? messages,
  ]) {
    return CustomThread(
      createdAt: thread?.createdAt,
      name: thread?.name,
      messages: messages,
    );
  }

  @override
  Map<String, dynamic> toJson() => _$CustomThreadToJson(this);

  factory CustomThread.fromJson(Map<String, dynamic> json) =>
      _$CustomThreadFromJson(json);
}
