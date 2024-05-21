import 'package:json_annotation/json_annotation.dart';
part 'initialize.g.dart';

///
/// [Initialize]
///
@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class Initialize extends JsonSerializable {
  final int id;
  final int channelId;
  final int code;
  final bool initValue;
  final String publicKey;

  Initialize({
    required this.id,
    required this.channelId,
    required this.code,
    required this.initValue,
    required this.publicKey,
  });

  get serverId => null;

  @override
  Map<String, dynamic> toJson() => _$InitializeToJson(this);

  factory Initialize.fromJson(Map<String, dynamic> json) =>
      _$InitializeFromJson(json);
}
