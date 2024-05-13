import 'package:json_annotation/json_annotation.dart';

import '../mixin/serializable.mixin.dart';
import 'custom_chan_perm.dart';
import 'message.entity.dart';

part 'custom_chan.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class CustomChan with SerializableMixin {
  final int position;

  final int channelType;

  final String channelName;

  final int? parentId;

  final List<UserMessage>? userMessage;

  final List<CustomChanPerm> perm;

  final int id;

  CustomChan({
    required this.position,
    required this.channelType,
    required this.channelName,
    required this.userMessage,
    this.parentId,
    required this.id,
    required this.perm,
  });

  @override
  Map<String, dynamic> toJson() => _$CustomChanToJson(this);

  factory CustomChan.fromJson(Map<String, dynamic> json) =>
      _$CustomChanFromJson(json);
}
