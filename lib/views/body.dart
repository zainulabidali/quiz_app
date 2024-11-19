import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/controllers/question_controller.dart';
import 'package:quiz_app/utils/containers.dart';
import 'package:quiz_app/views/progressbar.dart';
import 'package:quiz_app/views/question_card.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    QuestionController questionController = Get.find();
    PageController pageController = questionController.pageControllerInstance;
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/bgimg1.jpg",
          fit: BoxFit.fill,
        ),
        SafeArea(
            child: Column(
          children: [
           Progressbar(), 
            Obx(
              () => Text.rich( 
                TextSpan(
                    text: "Question ${questionController.questionNumber.value}",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: KSecondaryColor),
                    children: [
                      TextSpan(
                          text: "/${questionController.filterdQuestion.length}",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: KSecondaryColor))
                    ]),
              ),
            ),
            const Divider(
              thickness: 1.5,
            ),
            Expanded(
              child: PageView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: questionController.updateTheQnNum,
                  itemCount: questionController.filterdQuestion.length,
                  controller: pageController,
                  itemBuilder: (context, index) {
                    print(
                        "Question at Index $index: ${questionController.questions[index]}");
                    return QuestionCard(
                        question: questionController.filterdQuestion[index]);
                  }),
            )
          ],
        ))
      ],
    );
  }
}
