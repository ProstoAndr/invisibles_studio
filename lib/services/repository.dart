import 'package:sqflite/sqflite.dart';

import '../models/translation_model.dart';
import 'api_provider.dart';
import 'database_provider.dart';

class Repository {
  final ApiProvider _apiProvider = ApiProvider();
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  Future<String?> translateText(String text, String targetLanguage, sourceLanguage) async {
    return await _apiProvider.translateText(text, sourceLanguage, targetLanguage);
  }

  // Future<void> saveTranslation(TranslationModel translation) async {
  //   final db = await databaseProvider.database;
  //   await db.insert('translations', translation.toJson(),
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  // }
  //
  // Future<List<TranslationModel>> getTranslationsHistory() async {
  //   final db = await databaseProvider.database;
  //   final List<Map<String, dynamic>> maps = await db.query('translations');
  //
  //   return List.generate(maps.length, (i) {
  //     return TranslationModel(
  //       originalText: maps[i]['originalText'],
  //       translatedText: maps[i]['translatedText'],
  //     );
  //   });
  // }
  //
  // Future<void> deleteTranslation(TranslationModel translation) async {
  //   final db = await databaseProvider.database;
  //   await db.delete(
  //     'translations',
  //     where: 'originalText = ? AND translatedText = ?',
  //     whereArgs: [translation.originalText, translation.translatedText],
  //   );
  // }
}
