import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/login_Screen/loginPage/login.dart';
import 'package:quiz_app/utils/containers.dart';
import 'package:quiz_app/views/admin/admin_dashbord.dart';
import 'package:quiz_app/views/quiz_category.dart';

// ignore: must_be_immutable
class WellcomeScreen extends StatelessWidget {
  TextEditingController usernameController = TextEditingController();
  WellcomeScreen({super.key});

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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: KDefaultpading),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(
                    flex: 2,
                  ),
                  Text(
                    "Let's Paly Quiz",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const Text("Enter your information below"),
                  const Spacer(),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xff1c2341),
                      hintText: "Full Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      final username = usernameController.text
                          .trim(); // Trim input to avoid extra spaces

                      // Navigate based on username value
                      Get.to(() => username == "Admin" || username == "admin"
                          ? AdminDashboard()
                          : LoginPage());
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(KDefaultpading * 0.75),
                      decoration: const BoxDecoration(
                          gradient: KprimaryGradient,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Let's Start Quiz   ",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(color: Colors.black),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 2,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
