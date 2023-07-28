import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relt/components/heading.dart';
import 'package:relt/components/my_button.dart';
import '../components/my_textfield.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();

  void resetPassword(BuildContext context) async {
    String email = emailController.text;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Password reset email sent successfully, navigate to a success screen or show a success message
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // Pop back to login screen
    } catch (e) {
      // Handle password reset error or show an error message
      print('Error resetting password: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 70,
                    child: CustomHeading(text: "Forgot"),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Enter your email to reset your password',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    onChanged: (String value) {},
                  ),
                  const SizedBox(height: 25),
                  MyButton(
                    onTap: () => resetPassword(context),
                    buttonText: 'Reset',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
