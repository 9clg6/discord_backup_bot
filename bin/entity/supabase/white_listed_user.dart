import 'package:json_annotation/json_annotation.dart';

import '../../share/share.constants.dart';

part 'white_listed_user.g.dart';

///
/// [WhiteListedUser]
///
@JsonSerializable(explicitToJson: true)
class WhiteListedUser extends JsonSerializable {
  @JsonKey(name: userIdWhiteListKey)
  final int userId;
  final bool isWhiteListed;

  WhiteListedUser({
    required this.userId,
    required this.isWhiteListed,
  });

  @override
  Map<String, dynamic> toJson() => _$WhiteListedUserToJson(this);

  factory WhiteListedUser.fromJson(Map<String, dynamic> json) =>
      _$WhiteListedUserFromJson(json);
}
