import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/controllers/question_controller.dart';
import 'package:quiz_app/views/body.dart';

class Quizscreen extends StatefulWidget {
  final String category;
  const Quizscreen({super.key, required this.category});

  @override
  State<Quizscreen> createState() => _QuizscreenState();
}

class _QuizscreenState extends State<Quizscreen> {
  QuestionController questionController = Get.put(QuestionController());

  @override
  void initState() {
    super.initState();

    // Safely check if category is null or empty after widget build
    if (widget.category.isEmpty) {
      // Delay the snackbar until the widget is fully built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("Error", "Category is not provided.");
      });
    } else {
      questionController.setFilteredQuestions(widget.category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
              onPressed: questionController.nextQuestion,
              child: Text("Skip >>"))
        ],
      ),
      body: const Body(),
    );
  }
}
