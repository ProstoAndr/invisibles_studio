import 'package:bloc/bloc.dart';
import 'package:clipboard/clipboard.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invisibles_studio/models/translation_model.dart';
import 'package:invisibles_studio/services/database_provider.dart';
import 'package:invisibles_studio/services/repository.dart';

part 'translator_state.dart';

class TranslatorCubit extends Cubit<TranslatorState> {
  final Repository repository;
  final DatabaseProvider databaseProvider;

  bool _isDatabaseInitialized = false;

  TranslatorCubit(this.repository, this.databaseProvider) : super(Initial()) {
    _initDatabase();
  }

  bool flag = true;

  void _initDatabase() async {
    try {
      if (!_isDatabaseInitialized) {
        await databaseProvider.open();
        _isDatabaseInitialized = true;
        loadTranslationsHistory();
      }
    } catch (error) {
      emit(Error("Database initialization error: $error"));
    }
  }

  void translate(String text, sourceLanguageB, targetLanguageB) async {
    final String sourceLanguage = flag ? 'ru' : 'en';
    final String targetLanguage = flag ? 'en' : 'ru';

    print(sourceLanguageB);
    print(targetLanguageB);

    try {
      final translatedText =
          await repository.translateText(text, targetLanguage, sourceLanguage);

      if (translatedText != null) {
        await databaseProvider.insertTranslationHistory(
            text, translatedText, sourceLanguageB, targetLanguageB);

        final state = this.state as Content;

        emit(Content(translatedText, state.translations));
        loadTranslationsHistory();
      } else {
        emit(Error("Translation failed"));
      }
    } catch (error) {
      emit(Error("Error: $error"));
    }
  }

  void loadTranslationsHistory() async {
    try {
      final List<Map<String, dynamic>> historyEntries =
          await databaseProvider.getTranslationHistories();

      final List<TranslationModel> translations = historyEntries
          .map((entry) => TranslationModel(
              id: entry['id'],
              originalText: entry['original_text'],
              translatedText: entry['translated_text'],
              sourceLanguage: entry['source_language'],
              targetLanguage: entry['target_language']
      ))
          .toList();

      final content =
          state is Content ? (state as Content).translatedText : null;
      emit(Content(content, translations));
    } catch (error) {
      emit(Error("Error loading translation history: $error"));
    }
  }

  void deleteTranslationHistory(int id) async {
    try {
      await databaseProvider.deleteTranslationHistory(id);
      loadTranslationsHistory(); // Обновите список после удаления
    } catch (error) {
      emit(Error("Error deleting translation history: $error"));
    }
  }

  void change() {
    flag = !flag;
  }

  void copyText(text) async {
    await FlutterClipboard.copy(text);
  }
}
