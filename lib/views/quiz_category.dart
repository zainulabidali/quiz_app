import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quiz_app/controllers/question_controller.dart';
import 'package:quiz_app/login_Screen/AuthService/AuthService.dart';
import 'package:quiz_app/views/quizScreen.dart';

class QuizCategory extends StatefulWidget {
  QuizCategory({super.key});

  @override
  _QuizCategoryState createState() => _QuizCategoryState();
}

class _QuizCategoryState extends State<QuizCategory> {
  final QuestionController _questionController = Get.put(QuestionController());
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    User? user = _authService.getCurrentUser();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(user != null ? ' ${user.email}' : 'Quiz Category'),
        actions: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage("assets/logo_Quiz.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/bg img 5.jpg",
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: _questionController.savedTitleCategory.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: GestureDetector(
                    onTap: () {
                      print(
                          "Selected Category: ${_questionController.savedTitleCategory[index]}");

                      Get.to(() => Quizscreen(
                            category: _questionController.savedTitleCategory[index],
                          ));
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          "assets/Category-removebg-preview.png",
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _questionController.savedTitleCategory[index],
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  _questionController
                                      .savedSubtitleCategory[index],
                                  style: TextStyle(
                                    fontSize: 15,
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ));
                }),
          )
        ],
      ),
    );
  }
}
