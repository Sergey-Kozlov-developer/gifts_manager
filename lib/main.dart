import 'package:flutter/material.dart';
import 'package:gifts_manager/presentation/login/view/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const LoginPage(),
    );
  }
}
