import 'package:json_annotation/json_annotation.dart';
import '../../share/share.constants.dart';

part 'export.g.dart';

///
/// [Export]
///
@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class Export extends JsonSerializable {
  @JsonKey(name: serverSaveKey)
  String serverSave;

  @JsonKey(name: serverNameKey)
  String serverName;

  @JsonKey(name: idKey)
  int id;

  @JsonKey(name: serverIdKey)
  int serverId;

  @JsonKey(name: encryptedAesKeyKey)
  String encryptedAesKey;

  @JsonKey(name: ivKey)
  String iv;

  Export(
    this.id,
    this.serverName,
    this.serverId,
    this.encryptedAesKey,
    this.iv,
    this.serverSave,
  );

  @override
  Map<String, dynamic> toJson() => _$ExportToJson(this);

  factory Export.fromJson(Map<String, dynamic> json) => _$ExportFromJson(json);
}
