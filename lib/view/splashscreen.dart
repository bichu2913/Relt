// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:relt/aunthetication/auth.dart';

class SplashScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const SplashScreen({Key? key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    login(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('C:/canva/relt/assests/Metaversefundingvoguebusphotographermonth22story1.png'),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        const Positioned(
          top: 618,
          left: 51,
          child: Text(
            'Relt \n Fashion',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
              fontFamily: 'Roboto',
              fontSize: 48,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

login(BuildContext context) async {
  await Future.delayed(const Duration(seconds: 4));
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthPage()));
}




