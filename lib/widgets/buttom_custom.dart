import 'package:flutter/material.dart';

class ButtomCustom extends StatelessWidget {

  VoidCallback onPressed;
  String text;
  Color colorText;
  Color backgroundColor;
  double width;

  ButtomCustom({
    required this.onPressed,
    required this.text,
    required this.backgroundColor,
    required this.colorText,
    required this.width
});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: Size(width, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
      child: Text(text,style: TextStyle(color: colorText,fontWeight: FontWeight.bold),)
    );
  }
}
