import 'package:json_annotation/json_annotation.dart';
part 'initialize.g.dart';

///
/// [Initialize]
///
@JsonSerializable(explicitToJson: true)
class Initialize extends JsonSerializable {
  final int serverId;
  final int channelId;
  final int parameter;
  final bool isInitialized;
  final String publicKey;

  Initialize({
    required this.serverId,
    required this.channelId,
    required this.parameter,
    required this.isInitialized,
    required this.publicKey,
  });

  @override
  Map<String, dynamic> toJson() => _$InitializeToJson(this);

  factory Initialize.fromJson(Map<String, dynamic> json) =>
      _$InitializeFromJson(json);
}
