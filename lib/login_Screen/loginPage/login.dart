import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/login_Screen/AuthService/AuthService.dart';
import 'package:quiz_app/login_Screen/Signup_page/SignUp.dart';
import 'package:quiz_app/views/quiz_category.dart';

class LoginPage extends StatelessWidget {
  final AuthService _authService = AuthService(); // Use AuthService

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passController = TextEditingController();

    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // Background Image
            Image.asset(
              'assets/bg img 5.jpg',
              fit: BoxFit.fill,
              height: size.height,
              width: double.infinity,
            ),
            // Main Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Login",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _emailController,
                  hintText: "Email",
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: _passController,
                  hintText: "Password",
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  suffixIcon: Icons.visibility_outlined,
                ),
                const SizedBox(height: 20),
                _buildLoginButton(context, _emailController, _passController),
                const SizedBox(height: 20),
                _buildGuestButton(),
                const SizedBox(height: 10),
                _buildSignUpLink(context),
                _buildOrDivider(),
                _buildGoogleSignInButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    IconData? suffixIcon,
    bool obscureText = false,
  }) {
    return Container(
      width: MediaQuery.of(Get.context!).size.width * 0.8,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xff1c2341),
          hintText: hintText,
          prefixIcon: Icon(prefixIcon),
          suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // Helper method for the login button
  Widget _buildLoginButton(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passController) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 40,
      child: ElevatedButton(
      onPressed: () async {
  final email = emailController.text;
  final password = passController.text;

  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill all the fields")),
    );
  } else {
    UserCredential? userCredential = await _authService.signInWithEmail(email, password);

    if (userCredential != null) {
      // Login successful, navigate to QuizCategory
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QuizCategory()),
      );
    } else {
      // Login failed, show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email or password")),
      );
    }
  }
},

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 13, 147, 130),
        ),
        child: const Text(
          "LOGIN",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // Helper method for the guest button
  Widget _buildGuestButton() {
    return Container(
      width: MediaQuery.of(Get.context!).size.width * 0.8,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          Get.to(() => QuizCategory());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 13, 147, 130),
        ),
        child: const Text(
          "GUEST",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // Helper method for the sign-up link
  Widget _buildSignUpLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Signup_Page()),
        );
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an Account ? ",
            style: TextStyle(
                color: Color.fromARGB(255, 245, 243, 243), fontSize: 10),
          ),
          Text(
            " Sign Up ",
            style: TextStyle(
                color: Color.fromARGB(255, 245, 243, 243), fontSize: 15),
          ),
        ],
      ),
    );
  }

  // Helper method for the "OR" divider
  Widget _buildOrDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "OR",
            style: TextStyle(
                color: Color.fromARGB(255, 245, 243, 243), fontSize: 15),
          ),
        ],
      ),
    );
  }

  // Helper method for the Google sign-in button
  Widget _buildGoogleSignInButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            try {
              User? user = await _authService.signInWithGoogle();
              if (user != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => QuizCategory()),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Failed to sign in with Google: ${e.toString()}')),
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
    );
  }
}
