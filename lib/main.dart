import 'package:flutter/material.dart';
import 'package:ponta_tags/routes.dart';

//inicialização do aplicativo

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: routes,
    )
  );
}
