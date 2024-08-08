import 'package:json_annotation/json_annotation.dart';

import '../../share/share.constants.dart';

part 'change_log_state.g.dart';

///
/// [ChangeLogState]
///
@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class ChangeLogState extends JsonSerializable {
  @JsonKey(name: idKey)
  int serverId;

  @JsonKey(name: lastVersionRed)
  String version;

  ///
  /// Constructor
  ///
  ChangeLogState(
    this.serverId,
    this.version,
  );

  @override
  Map<String, dynamic> toJson() => _$ChangeLogStateToJson(this);

  factory ChangeLogState.fromJson(Map<String, dynamic> json) => _$ChangeLogStateFromJson(json);
}