import 'package:json_annotation/json_annotation.dart';

import '../mixin/serializable.mixin.dart';
import 'custom_chan.dart';
import 'custom_role.entity.dart';

part 'guild_export.entity.g.dart';

///
/// [GuildExport]
///
@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class GuildExport with SerializableMixin {
  final String? guildName;
  final List<CustomRole>? roles;
  final List<CustomChan>? chans;
  final int guildId;
  int? timestamp;

  GuildExport({
    required this.guildName,
    required this.roles,
    required this.chans,
    required this.guildId,
  }) {
    timestamp = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Map<String, dynamic> toJson() => _$GuildExportToJson(this);

  factory GuildExport.fromJson(Map<String, dynamic> json) =>
      _$GuildExportFromJson(json);

  @override
  String toString() {
    return 'Name; $guildName with ${roles?.length} roles with permissions : ${roles?.map((e) => '${e.permissionValue} ').toList()} and ${chans?.length} chans';
  }
}
