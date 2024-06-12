import 'package:flutter/material.dart';
import 'config.dart';
import 'package:admin/LoginPage.dart';

void main() {
  runApp(MyApp(apiUrl: Config.apiUrl));
}

class MyApp extends StatelessWidget {
  final String apiUrl;

  const MyApp({Key? key, required this.apiUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(apiUrl: apiUrl),
    );
  }
}
