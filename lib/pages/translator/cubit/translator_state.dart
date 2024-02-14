part of 'translator_cubit.dart';

@immutable
sealed class TranslatorState extends Equatable {
  const TranslatorState();

  @override
  List<Object?> get props => [];
}

class Initial extends TranslatorState {}

class Content extends TranslatorState {
  final String? translatedText;
  final List<TranslationModel> translations;

  Content(this.translatedText, this.translations);

  @override
  List<Object?> get props => [translatedText, translations];
}

class Error extends TranslatorState {
  final String errorMessage;

  Error(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}