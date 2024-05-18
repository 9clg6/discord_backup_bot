import 'package:nyxx/nyxx.dart';
import 'package:supabase/supabase.dart';

///
/// Constants (don't judge me for this file)
///

late NyxxGateway client;

late SupabaseClient supabase;

const String discordApiKeyKey = 'DISCORD_API_KEY';
const String supabaseApiKeyKey = 'SUPABASE_API_KEY';
const String supabaseDatabaseAddress = 'SUPABASE_ADDRESS';

const String saveCollectionKey = 'save';
const String initCollection = 'initialization';
