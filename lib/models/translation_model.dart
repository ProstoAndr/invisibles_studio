class TranslationModel {
  final int id;
  final String originalText;
  final String translatedText;
  final String sourceLanguage;
  final String targetLanguage;

  TranslationModel({
    required this.id,
    required this.originalText,
    required this.translatedText,
    required this.sourceLanguage,
    required this.targetLanguage,
  });
}
