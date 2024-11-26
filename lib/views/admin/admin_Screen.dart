import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                controller: questionController.questionControllerText,
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(255, 89, 103, 115),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  labelText: "Enter the Question",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              for (var i = 0; i < 4; i++)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: questionController.optionalControllers[i],
                    decoration: InputDecoration(
                      fillColor: const Color.fromARGB(255, 89, 103, 115),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "options ${i + 1}",
                    ),
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: questionController.correctAnswerController,
                  decoration: const InputDecoration(
                    hintMaxLines: 1,
                    fillColor: Color.fromARGB(255, 89, 103, 115),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: "Correct Answer (0 - 3)",
                  ),
                  keyboardType:
                      TextInputType.number, // Restricts input to numbers
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-3]')), // Only allows numbers 0-3
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 44, 139, 120))),
                onPressed: () {
                  if (questionController.questionControllerText.text.isEmpty) {
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
                    addQuestions();
                    print(
                        ">>question collected ${questionController.questionControllerText.text}");
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
    final String questionText = questionController.questionControllerText.text;
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

    // Save question to both Hive and Firebase
    await questionController.saveQuestion(newQuestion);

    // Clear input fields
    questionController.questionControllerText.clear();
    questionController.optionalControllers
        .forEach((controller) => controller.clear());
  }
}
