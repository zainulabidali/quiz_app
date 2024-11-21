import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:quiz_app/login_Screen/AuthService/AuthService.dart';
import 'package:quiz_app/login_Screen/Signup_page/SignUp.dart';
import 'package:quiz_app/views/quiz_category.dart';

class LoginPage extends StatelessWidget {
  final AuthService _authService = AuthService(); // Use AuthService

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/bg img 5.jpg',
                  fit: BoxFit.fill,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Login",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: size.width * 0.8,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                          decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xff1c2341),
                        hintText: "Email",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                      )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: size.width * 0.8,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xff1c2341),
                            hintText: "password",
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: const Icon(Icons.visibility_outlined),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      // height: size.height * 0.1,
                      width: size.width * 0.8,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 13, 147, 130)),
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      // height: size.height * 0.1,
                      width: size.width * 0.8,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(QuizCategory());
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 13, 147, 130)),
                        child: const Text(
                          "GUEST",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Signup_Page()));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an Account ? ",
                            style: TextStyle(
                                color: Color.fromARGB(255, 245, 243, 243),
                                fontSize: 10),
                          ),
                          Text(
                            " Sign Up ",
                            style: TextStyle(
                                color: Color.fromARGB(255, 245, 243, 243),
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    OrDivider(),
                    // Google sign-in button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            print("object");
                            try {
                              User? user =
                                  await _authService.signInWithGoogle();
                              print(user);

                              // If sign-in is successful, navigate to HomePage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QuizCategory()),
                              );
                              print('Google sign-in success');
                            } catch (e) {
                              print(e.toString());

                              // Show error message in Snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Failed to sign in with Google: ${e.toString()}')),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.white),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              "assets/google (2).png",
                              height: 40,
                              width: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
