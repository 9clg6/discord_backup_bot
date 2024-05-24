import 'package:nyxx/nyxx.dart';

///
/// Constants (don't judge me for this file)
///

late NyxxGateway client;

const String discordApiKeyKey = 'DISCORD_API_KEY';
const String supabaseApiKeyKey = 'SUPABASE_API_KEY';
const String supabaseDatabaseAddress = 'SUPABASE_ADDRESS';

const String saveCollectionKey = 'save';
const String initCollectionKey = 'initialization';
const String whiteListCollectionKey = 'whiteList';

const String encryptedAesKeyKey = 'encryptedAes';
const String serverSaveKey = 'server';
const String serverNameKey = 'serverName';
const String idKey = 'id';
const String ivKey = 'iv';
const String serverIdKey = 'serverId';
const String isWhiteListedKey = 'isWhiteListed';
const String userIdWhiteListKey = 'user_id';

const int ivConst = 16;
const int aesLength = 32;
