import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static const String databaseName = 'translator.db';
  static const int databaseVersion = 2;

  static const String translationHistoryTable = 'translation_history';
  static const String columnId = 'id';
  static const String columnOriginalText = 'original_text';
  static const String columnTranslatedText = 'translated_text';
  static const String columnSourceLanguage = 'source_language';
  static const String columnTargetLanguage = 'target_language';

  late Database _database;

  Future<void> open() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, databaseName);

    _database = await openDatabase(path, version: databaseVersion,
        onCreate: (Database db, int version) async {
          await db.execute('''
          CREATE TABLE $translationHistoryTable (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnOriginalText TEXT NOT NULL,
            $columnTranslatedText TEXT NOT NULL,
            $columnSourceLanguage TEXT,
            $columnTargetLanguage TEXT
          )
        ''');
        });
  }

  Future<Database> get database async {
    if (_database.isOpen) {
      return _database;
    } else {
      await open();
      return _database;
    }
  }

  Future<List<Map<String, dynamic>>> getTranslationHistories() async {
    final db = await database;
    return db.query(translationHistoryTable, orderBy: '$columnId DESC');
  }

  Future<void> insertTranslationHistory(String originalText, String translatedText, String sourceLanguage, String targetLanguage) async {
    final db = await database;
    await db.insert(
      translationHistoryTable,
      {
        columnOriginalText: originalText,
        columnTranslatedText: translatedText,
        columnSourceLanguage: sourceLanguage,
        columnTargetLanguage: targetLanguage,
      },
    );
  }

  Future<void> deleteTranslationHistory(int id) async {
    final db = await database;
    await db.delete(
      translationHistoryTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async => _database.close();
}