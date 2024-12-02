import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/controllers/question_controller.dart';
import 'package:quiz_app/login_Screen/AuthService/AuthService.dart';
import 'package:quiz_app/utils/containers.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/views/quiz_category.dart';
import 'package:quiz_app/views/wellcome.dart';

class Scorepage extends StatefulWidget {
  const Scorepage({super.key});

  @override
  State<Scorepage> createState() => _ScorepageState();
}

class _ScorepageState extends State<Scorepage> {
  final AuthService _authService = AuthService(); // Use AuthService

  QuestionController questionController = Get.put(QuestionController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/bg img 5.jpg",
              fit: BoxFit.fill,
            ),
            Column(
              children: [
                Spacer(),
                Text(
                  "Quiz Result",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Lottie.asset(
                  "assets/Animation - 1732518025124.json",
                ),
                Text(
                  "Congratulations!",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "YOUR SCORE",
                  style: TextStyle(fontSize: 20, color: KSecondaryColor),
                ),
                SizedBox(
                  height: 20,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${questionController.numofCorrectAns} ",
                      style: TextStyle(
                        color: questionController.numofCorrectAns <=
                                questionController.filteredQuestions.length / 3
                            ? Colors.red
                            : questionController.numofCorrectAns <=
                                    2 *
                                        questionController
                                            .filteredQuestions.length /
                                        3
                                ? Colors.orange
                                : Colors.green,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "/ ${questionController.filteredQuestions.length}",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                // Displaying a conditional message
                if (questionController.numofCorrectAns <=
                    questionController.filteredQuestions.length / 3)
                  Text(
                    "Keep practicing! You'll get better.",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  )
                else if (questionController.numofCorrectAns <=
                    2 * questionController.filteredQuestions.length / 3)
                  Text(
                    "Good job! You're improving.",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 20,
                    ),
                  )
                else
                  Text(
                    "Excellent! You're a quiz master!",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                    ),
                  ),

                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    _authService.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WellcomeScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        const Color.fromARGB(255, 9, 192, 152), // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12), // Padding inside the button
                    elevation: 5, // Shadow effect
                  ),
                  child: Text(
                    "Quit",
                    style: TextStyle(
                      fontSize: 16, // Text size
                      fontWeight: FontWeight.bold, // Text weight
                    ),
                  ),
                ),

                Spacer()
              ],
            )
          ],
        ),
      ),
    );
  }
}
