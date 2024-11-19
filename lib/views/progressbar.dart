import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/controllers/question_controller.dart';
import 'package:quiz_app/utils/containers.dart';

class Progressbar extends StatelessWidget {
  const Progressbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 35,
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 101, 101, 102), width: 3),
          borderRadius: BorderRadius.circular(50)),
      child: GetBuilder<QuestionController>(
          init: QuestionController(),
          builder: (controller) {
            return Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      width: constraints.maxWidth * controller.animation.value,
                      decoration: BoxDecoration(
                          gradient: KprimaryGradient,
                          borderRadius: BorderRadius.circular(50)),
                    );
                  },
                ),
                Positioned.fill(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: KDefaultpading / 2),
                  child: Row(
                    children: [
                      Text("${(controller.animation.value * 60).round()}"),
                    ],
                  ),
                ))
              ],
            );
          }),
    );
  }
}
