import 'dart:io';

import '../entity/supabase/change_log_state.dart';
import '../share/share.constants.dart';
import 'database.service.dart';

///
/// [ChangeLogService]
///
class ChangeLogService {
  /// Channel id
  final int channelId;

  /// Server id
  final int serverId;

  /// Changelog
  StringBuffer? changelog;

  /// Current bot version
  String? currentVersion;

  ///
  /// Factory
  ///
  factory ChangeLogService(
    int serverId,
    int channelId,
  ) =>
      ChangeLogService._(
        serverId,
        channelId,
      );

  ///
  /// Private constructor to prevent external instantiation.
  ///
  ChangeLogService._(
    this.channelId,
    this.serverId,
  );

  ///
  /// Save state
  ///
  Future<void> saveState() async {
    return await DatabaseService().saveData(
      ChangeLogState(serverId, currentVersion ?? ''),
      collection: changeLogCollectionKey,
    );
  }

  ///
  /// Fetch state
  ///
  Future<String?> fetchVersion() async {
    final ChangeLogState? lastState = await DatabaseService().fetchDocument(
      changeLogCollectionKey,
      idKey,
      serverId,
      ChangeLogState.fromJson,
    );

    return lastState?.version;
  }

  ///
  /// Get latest change log in string
  ///
  Future<void> getLatestChangelog() async {
    List<String>? changeLog = await _readChangelog();

    if (changeLog == null) return;

    int versionCounter = 0;
    int cutOffIndex = changeLog.length;

    for (int i = 0; i < changeLog.length; i++) {
      final String line = changeLog[i];

      if (line.startsWith('##')) {
        versionCounter += 1;
        if (versionCounter == 1) {
          currentVersion = line.split(' ')[1];
        }

        if (versionCounter == 2) {
          cutOffIndex = i;

          break;
        }
      }
    }

    // Si une deuxième version a été trouvée, couper la liste à cet endroit
    if (cutOffIndex != changeLog.length) {
      changeLog = changeLog.sublist(0, cutOffIndex);
    }

    // Retourne le changelog formaté en une seule chaîne de caractères
    final StringBuffer finalString = StringBuffer()
      ..write("💡 Nouvelle version !\n")
      ..write(changeLog.join('\n'));

    changelog = finalString;
  }

  ///
  /// Read changelog file
  ///
  Future<List<String>?> _readChangelog() async {
    const String filePath = 'CHANGELOG.md';

    try {
      return File(filePath).readAsLinesSync();
    } catch (e) {
      return null;
    }
  }
}
