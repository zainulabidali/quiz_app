import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quiz_app/controllers/question_controller.dart';
import 'package:quiz_app/models/question_models.dart';

class AdminScreen extends StatelessWidget {
  final String quizCategory;
  AdminScreen({
    super.key,
    required this.quizCategory,
  });
  final QuestionController questionController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Question to $quizCategory"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: questionController.questionControllertext,
                decoration: const InputDecoration(
                  labelText: "Question",
                ),
              ),
              for (var i = 0; i < 4; i++)
                TextFormField(
                  controller: questionController.optionalControllers[i],
                  decoration: InputDecoration(
                    labelText: "options ${i + 1}",
                  ),
                ),
              TextFormField(
                controller: questionController.correctAnswerController,
                decoration: const InputDecoration(
                  labelText: "Correct Answer (0-3)",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (questionController.questionControllertext.text.isEmpty) {
                    Get.snackbar("Error", "Please enter a question");
                  } else if (questionController
                      .optionalControllers[0].text.isEmpty) {
                    Get.snackbar("Error", "Please enter an option");
                  } else if (questionController
                      .optionalControllers[1].text.isEmpty) {
                    Get.snackbar("Error", "Please enter an option");
                  } else if (questionController
                      .optionalControllers[2].text.isEmpty) {
                    Get.snackbar("Error", "Please enter an option");
                  } else if (questionController
                      .optionalControllers[3].text.isEmpty) {
                    Get.snackbar("Error", "Please enter an option");
                  } else {
                    print("questons collected 0");
                    addQuestions();
                    print(
                        ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>question collected ${questionController.questionControllertext.text}");
                  }
                },
                child: Text("Add Questions "),
              )
            ],
          ),
        ),
      ),
    );
  }

  void addQuestions() async {
    // collecting question from the text controller
    final String questionText = questionController.questionControllertext.text;
    final List<String> options = questionController.optionalControllers
        .map((controller) => controller.text)
        .toList();
    final int correctAnswer =
        int.tryParse(questionController.correctAnswerController.text) ?? 1;

    final Question newQuestion = Question(
        id: DateTime.now().millisecondsSinceEpoch, // unique
        questions: questionText,
        category: quizCategory,
        options: options,
        answer: correctAnswer);

    // save the questions shareprefrence
    await questionController.saveQuestionToSharedPreferences(newQuestion);
    Get.snackbar("Added", "Question Added");
    questionController.questionControllertext.clear();
    questionController.optionalControllers.forEach((element) {
      element.clear();
    });
    print(questionController.questions);
  }
}
