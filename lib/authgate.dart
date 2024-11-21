import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/login_Screen/AuthService/AuthService.dart';
import 'package:quiz_app/views/quiz_category.dart';
import 'package:quiz_app/views/wellcome.dart';

class AuthGate extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.userState,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while waiting for auth state
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // User is authenticated
          return QuizCategory();
        } else {
          // User is not authenticated
          return WellcomeScreen();
        }
      },
    );
  }
}
