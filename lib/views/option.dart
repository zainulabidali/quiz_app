import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/controllers/question_controller.dart';
import 'package:quiz_app/utils/containers.dart';

class Option extends StatelessWidget {
  final String text;
  final int index;
  final VoidCallback press;
  const Option(
      {super.key,
      required this.text,
      required this.index,
      required this.press});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionController>(
      init: QuestionController(),
      builder: (controller) {
        Color getTheRightColor() {
          if (controller.isAnswer) {
            if (index == controller.correctAns) {
              return KGreenColor;
            } else if (index == controller.selectedAns &&
                controller.selectedAns != controller.correctAns) {
              return KRedColor;
            }
          }
          return KGrayColor;
        }

        IconData getTheRightIcon() {
          return getTheRightColor() == KRedColor ? Icons.close : Icons.done;
        }

        return GestureDetector(
            onTap: press,
            child: Container(
              margin: EdgeInsets.only(top: KDefaultpading),
              padding: EdgeInsets.all(KDefaultpading),
              decoration: BoxDecoration(
                  border: Border.all(color: getTheRightColor()),
                  borderRadius: BorderRadius.circular(25)),
              child: Row(
                children: [
                  Text(
                    "${index + 1}. $text",
                    style: TextStyle(color: getTheRightColor(), fontSize: 16),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: getTheRightColor() == KGrayColor
                          ? Colors.transparent
                          : getTheRightColor(),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: getTheRightColor()),
                    ),
                    child: getTheRightColor() ==KGrayColor ? null : Icon(getTheRightIcon(),size: 16,),
                  )
                ],
              ),
            ));
      },
    );
  }
}
