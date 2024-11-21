import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/controllers/question_controller.dart';
import 'package:quiz_app/utils/containers.dart';

class Scorepage extends StatefulWidget {
  const Scorepage({super.key});

  @override
  State<Scorepage> createState() => _ScorepageState();
}

class _ScorepageState extends State<Scorepage> {
  QuestionController questionController = Get.put(QuestionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/bg img 5.jpg",
            fit: BoxFit.fill,
          ),
          Column(
            children: [
              const Spacer(
                flex: 3,
              ),
              Text(
                "Score",
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: KSecondaryColor),
              ),
              Spacer(),
              Text(
                "${questionController.numofCorrectAns * 10}/ ${questionController.filteredQuestions.length * 10}",
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: KSecondaryColor),
              ),
              Spacer(
                flex: 3,
              )
            ],
          )
        ],
      ),
    );
  }
}
