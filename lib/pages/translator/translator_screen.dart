import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invisibles_studio/models/translation_model.dart';

import 'cubit/translator_cubit.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({Key? key}) : super(key: key);

  @override
  _TranslatorScreenState createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  String text1 = 'Русский';
  String text2 = 'Английский';

  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.6),
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.86),
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(16),
                              bottomLeft: Radius.circular(16)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 64.0, left: 16, right: 16),
                          child: Column(
                            children: [
                              const Text('Invisibles Studio',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 24)),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Row(
                                  children: [
                                    Text(text1),
                                    const Icon(Icons.arrow_forward),
                                    Text(text2)
                                  ],
                                ),
                              ),
                              const Divider(
                                color: Colors.black,
                                thickness: 1,
                              ),
                              TextField(
                                maxLines: null,
                                style: const TextStyle(fontSize: 24),
                                controller: _textEditingController,
                                decoration: InputDecoration(
                                  suffix: Column(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            _textEditingController.text = '';
                                            setState(() {
                                              _isVisible = false;
                                            });
                                          },
                                          icon: const Icon(Icons.clear)),
                                      IconButton(
                                          onPressed: () {
                                            context
                                                .read<TranslatorCubit>()
                                                .copyText(
                                                    _textEditingController
                                                        .text);
                                          },
                                          icon: const Icon(Icons.copy))
                                    ],
                                  ),
                                  border: InputBorder.none,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintText: 'Введите текст для перевода',
                                ),
                                onChanged: (text) {
                                  if (text.trim().isNotEmpty) {
                                    EasyDebounce.debounce('debouncer1',
                                        const Duration(milliseconds: 1500),
                                        () {
                                      context
                                          .read<TranslatorCubit>()
                                          .translate(text, text1, text2);
                                      setState(() {
                                        _isVisible = true;
                                      });
                                    });
                                  } else {
                                    setState(() {
                                      _isVisible = false;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _isVisible,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(text2),
                                  const Icon(Icons.arrow_forward),
                                  Text(text1)
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                              ),
                              BlocBuilder<TranslatorCubit, TranslatorState>(
                                builder: (context, state) {
                                  if (state is Content &&
                                      state.translatedText != null) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${state.translatedText}',
                                            style:
                                                const TextStyle(fontSize: 24),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  _textEditingController
                                                      .text = '';
                                                  setState(() {
                                                    _isVisible = false;
                                                  });
                                                },
                                                icon:
                                                    const Icon(Icons.clear)),
                                            IconButton(
                                                onPressed: () {
                                                  context
                                                      .read<TranslatorCubit>()
                                                      .copyText(
                                                          '${state.translatedText}');
                                                },
                                                icon: const Icon(Icons.copy))
                                          ],
                                        )
                                      ],
                                    );
                                  } else if (state is Error) {
                                    return Text(
                                        'Ошибка: ${state.errorMessage}');
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                'История переводов',
                style: TextStyle(fontSize: 24),
              ),
            ),
            Expanded(flex: 1, child: _buildHistoryList()),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsetsDirectional.only(start: 32, end: 32, bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text1, style: const TextStyle(fontSize: 16),),
            IconButton(
                onPressed: () {
                  setState(() {
                    final temp = text1;
                    text1 = text2;
                    text2 = temp;
                    context.read<TranslatorCubit>().change();
                  });
                },
                icon: const Icon(Icons.repeat)),
            Text(
              text2,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return BlocBuilder<TranslatorCubit, TranslatorState>(
      builder: (context, state) {
        if (state is Content) {
          final List<TranslationModel> translations = state.translations;

          if (translations.isEmpty) {
            return const Center(
              child: Text('История переводов пуста'),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: ListView.builder(
              itemCount: translations.length,
              itemBuilder: (context, index) {
                final translation = translations[index];
                return Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(translation.sourceLanguage),
                                      const Icon(Icons.arrow_forward),
                                      Text(translation.targetLanguage),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        context
                                            .read<TranslatorCubit>()
                                            .deleteTranslationHistory(
                                                translation.id);
                                      },
                                      icon: const Icon(Icons.clear)),
                                ],
                              ),
                              const Divider(
                                indent: 1,
                              ),
                              Text(
                                translation.originalText,
                                style: const TextStyle(fontSize: 19),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                translation.translatedText,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black.withOpacity(0.5)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
