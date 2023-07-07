import 'package:flutter/material.dart';

class CustomHeading extends StatelessWidget {
  final String text;
  final double textScaleFactor;
  final TextAlign textAlign;

  const CustomHeading({
    Key? key,
    required this.text,
    this.textScaleFactor = 4.0,
    this.textAlign = TextAlign.left,
    
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      
      text,
      textScaleFactor: textScaleFactor,
      textAlign: textAlign,
    );
  }
}
