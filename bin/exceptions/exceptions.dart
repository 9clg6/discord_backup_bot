///
/// [FetchRolesException]
///
class FetchRolesException implements Exception {
  String cause;

  FetchRolesException(this.cause);
}

///
/// [FetchChannelsException]
///
class FetchChannelsException implements Exception {
  String cause;

  FetchChannelsException(this.cause);
}

///
/// [BuildChannelException]
///
class BuildChannelException implements Exception {
  String cause;

  BuildChannelException(this.cause);
}

///
/// [BuildCategoryException]
///
class BuildCategoryException implements Exception {
  String cause;

  BuildCategoryException(this.cause);
}

///
/// [CreateRoleException]
///
class CreateRoleException implements Exception {
  String cause;

  CreateRoleException(this.cause);
}

///
/// [InitializationException]
///
class InitializationException implements Exception {
  String cause;

  InitializationException(this.cause);
}

///
/// [CancelBotException]
///
class CancelBotException implements Exception {
  String cause;

  CancelBotException(this.cause);
}
