import 'package:json_annotation/json_annotation.dart';
import '../mixin/serializable.mixin.dart';

part 'custom_chan_perm.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class CustomChanPerm with SerializableMixin {
  final int allowValue;

  final int denyValue;

  final int permType;

  final int snowflakeId;

  final bool isEveryone;

  CustomChanPerm({
    required this.allowValue,
    required this.denyValue,
    required this.permType,
    required this.snowflakeId,
   this.isEveryone = false,
  });

  @override
  Map<String, dynamic> toJson() => _$CustomChanPermToJson(this);

  factory CustomChanPerm.fromJson(Map<String, dynamic> json) =>
      _$CustomChanPermFromJson(json);
}
