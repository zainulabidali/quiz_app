import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quiz_app/authgate.dart';
import 'package:quiz_app/controllers/question_controller.dart';
import 'package:quiz_app/views/admin/scorePage.dart';
import 'package:quiz_app/views/quiz_category.dart';
import 'package:quiz_app/views/wellcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox("categoriesBox");
  await Hive.openBox("questionsBox");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
     Get.put(QuestionController(), permanent: true);   // >>>>>>>>>>>>
    return GetMaterialApp(
      title: 'Quiz App',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 69, 111, 169)),
        useMaterial3: true,
      ),
      home: AuthGate(),
    );
  }
}
