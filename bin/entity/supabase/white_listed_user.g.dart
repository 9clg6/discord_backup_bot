// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'white_listed_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhiteListedUser _$WhiteListedUserFromJson(Map<String, dynamic> json) =>
    WhiteListedUser(
      userId: (json['user_id'] as num).toInt(),
      isWhiteListed: json['isWhiteListed'] as bool,
    );

Map<String, dynamic> _$WhiteListedUserToJson(WhiteListedUser instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'isWhiteListed': instance.isWhiteListed,
    };
