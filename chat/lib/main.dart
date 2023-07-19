import 'package:chat/pages/auth_or_app_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
            backgroundColor: Colors.white,
            accentColor: Colors.blueAccent,
            errorColor: Colors.red),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        useMaterial3: true,
      ),
      home: const AuthOrAppPage(),
    );
  }
}
