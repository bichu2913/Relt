import 'package:flutter/material.dart';
import 'package:relt/components/heading.dart';

import '../components/MyButton.dart';
import '../components/MyTextField.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  void resetPassword() {
    // Implement your reset password logic here
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
                    child:CustomHeading(text:"Forgot")
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
                      controller: TextEditingController(),
                      hintText: 'Email',
                      obscureText: false, onChanged: (String value) {  },
                    ),
                  const SizedBox(height: 25),
                     MyButton(
                onTap: resetPassword,
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
