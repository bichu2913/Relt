// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relt/components/heading.dart';
import 'package:relt/components/my_button.dart';
import 'package:relt/components/my_textfield.dart';




class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmController = TextEditingController();

void signUp() async {
  if (passwordController.text == confirmController.text) {
    try {
      showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

       FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
        
      );
         // Set the user role field in Firestore
    String userId = emailController.text;
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'email': emailController.text,
      'role': 'regular', // Set the default user role to "regular"
    });
      // Successful sign-up, navigate to the next screen or show a success message
     Navigator.pop(context);
     Navigator.popUntil(context, (route) => route.isFirst);
     } 
    on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(context, e.code);
    } catch (e) {
      Navigator.pop(context);
      
    }
  } else {
   
    showErrorMessage(context, 'password-mismatch');
  }
}

void showErrorMessage(BuildContext context, String errorCode) {
  String errorMessage;
  if (errorCode == 'email-already-in-use') {
    errorMessage = 'Email already in use';
  } else if (errorCode == 'weak-password') {
    errorMessage = 'Weak password';
  } else if (errorCode == 'password-mismatch') {
    errorMessage = 'Passwords do not match';
  } else {
    errorMessage = 'An error occurred';
  }

  showDialog(
    context: context,
    builder: (context) => buildErrorDialog(context, errorMessage),
  );
}

AlertDialog buildErrorDialog(BuildContext context, String errorMessage) {
  return AlertDialog(
    backgroundColor: Colors.deepPurple,
    title: const Center(
      child: Text(
        'Error',
        style: TextStyle(color: Colors.white),
      ),
    ),
    content: Text(
      errorMessage,
      style: const TextStyle(color: Colors.white),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text(
          'OK',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ],
  );
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
                  
                    const SizedBox(height: 10),
                    MyTextField(
                     controller: emailController,
                      hintText: 'Email',
                      obscureText: false, onChanged: (String value) {  },
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true, onChanged: (String value) {  },
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: confirmController,
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


