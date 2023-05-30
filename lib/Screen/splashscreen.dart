import 'package:flutter/material.dart';
import 'package:relt/Screen/loginscreen.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    login(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              // width: width1,
              // height: height1 * 1.8,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Metaversefundingvoguebusphotographermonth22story1.png'),
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
        ),
      ],
    );
  }
}

login(BuildContext context) async {
  await Future.delayed(const Duration(seconds: 4));
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
}



