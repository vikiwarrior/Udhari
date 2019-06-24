import 'package:flutter/material.dart';
import 'package:udhari_2/Utils/HandleSignIn.dart';

void main() => runApp(UdhariApp());

class UdhariApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Udhari",
      theme: ThemeData.light(),
      home: HandleSignIn(),
    );
  }
}
