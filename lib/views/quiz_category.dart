import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quiz_app/controllers/question_controller.dart';
import 'package:quiz_app/views/quizScreen.dart';

class QuizCategory extends StatelessWidget {
  QuizCategory({super.key});
  final QuestionController _questionController = Get.put(QuestionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/bgimg1.jpg",
            fit: BoxFit.fill,
          ),
          GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: _questionController.savedTitleCategory.length,
              itemBuilder: (context, index) {
                return Card(
                    child: GestureDetector(
                  onTap: () {
                    
                    print(
                        "Selected Category: ${_questionController.savedTitleCategory[index]}");

                    Get.to(Quizscreen(
                        category:
                            _questionController.savedTitleCategory[index]));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.question_answer),
                      Text(_questionController.savedTitleCategory[index]),
                      Text(_questionController.savedSubtitleCategory[index]),
                    ],
                  ),
                ));
              })
        ],
      ),
    );
  }
}
