import 'package:json_annotation/json_annotation.dart';
import 'package:supabase/supabase.dart';

///
/// Database services
///
class DatabaseService {
  SupabaseClient? supabase;

  /// Singleton's instance
  static DatabaseService? _instance;

  ///
  /// Factory
  ///
  factory DatabaseService([
    String? address,
    String? apiKey,
  ]) {
    return _instance ??= DatabaseService._internal(
      address!,
      apiKey!,
    );
  }

  ///
  /// Private constructor
  ///
  DatabaseService._internal(
    String address,
    String apiKey,
  ) {
    supabase = SupabaseClient(address, apiKey);
  }

  ///
  /// Save data
  ///
  Future<void> saveData<T extends JsonSerializable>(
    T export, {
    required String collection,
  }) async {
    await supabase?.from(collection).upsert(export.toJson());
  }

  ///
  /// Fetch all documents
  ///
  Future<List<T>?> fetchDocuments<T extends JsonSerializable>(
    String collectionKey,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final PostgrestList? response =
        await supabase?.from(collectionKey).select();

    return response?.map<T>((json) => fromJson(json)).toList();
  }

  ///
  ///  Fetch document
  ///
  Future<T?> fetchDocument<T extends JsonSerializable>(
    String collectionKey,
    String fieldName,
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final PostgrestList? response = await supabase
        ?.from(collectionKey)
        .select()
        .eq(fieldName, value)
        .limit(1);

    if (response == null || response.isEmpty) {
      return null;
    }

    return fromJson(response.first);
  }
}
