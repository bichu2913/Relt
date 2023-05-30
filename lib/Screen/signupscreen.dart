import 'package:flutter/material.dart';
import 'package:relt/components/heading.dart';
import 'package:relt/components/myTextField.dart';

import '../components/MyButton.dart';

class SignupPage extends StatelessWidget {
  SignupPage({Key? key}) : super(key: key);

  void signUp() {
    // Implement your sign-up logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
              const SizedBox(
                height: 70,
                child: CustomHeading(text:"Signup"),
              ),
              const SizedBox(height: 50),
              Text(
                'Join us and create an account!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    MyTextField(
                      controller: TextEditingController(),
                      hintText: 'Full Name',
                      obscureText: false, onChanged: (String value) {  },
                      
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: TextEditingController(),
                      hintText: 'Email',
                      obscureText: false, onChanged: (String value) {  },
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: TextEditingController(),
                      hintText: 'Password',
                      obscureText: true, onChanged: (String value) {  },
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: TextEditingController(),
                      hintText: 'Confirm Password',
                      obscureText: true, onChanged: (String value) {  },
                    ),
                    const SizedBox(height: 25),
                    MyButton(
                onTap: signUp,
                buttonText: 'Sign Up',
              ),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


