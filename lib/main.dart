import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invisibles_studio/services/database_provider.dart';
import 'package:invisibles_studio/services/repository.dart';

import 'pages/translator/cubit/translator_cubit.dart';
import 'pages/translator/translator_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DatabaseProvider databaseProvider = DatabaseProvider();
    final Repository repository = Repository();
    final TranslatorCubit translatorCubit =
    TranslatorCubit(repository, databaseProvider);
    return MaterialApp(
      title: 'Translator App',
      home: BlocProvider(
        create: (context) => translatorCubit,
        child: const TranslatorScreen(),
      ),
    );
  }
}
