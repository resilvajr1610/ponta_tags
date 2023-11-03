import 'package:flutter/material.dart';

class InputTextCustom extends StatelessWidget {

  TextEditingController controller;
  TextInputType textInputType;
  String hint;

  InputTextCustom({
    required this.controller,
    required this.textInputType,
    required this.hint,
});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.8,
      child: TextFormField(
          controller: this.controller,
          keyboardType: textInputType,
          style: TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.black,
              )
          )
      ),
    );
  }
}
