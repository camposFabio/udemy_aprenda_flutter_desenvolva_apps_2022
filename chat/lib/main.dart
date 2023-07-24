import 'package:chat/core/services/notification/chat_notification_service.dart';
import 'package:chat/pages/auth_or_app_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChatNotificationService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
              backgroundColor: Colors.white,
              accentColor: Colors.blueAccent,
              errorColor: Colors.red),
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            actionsIconTheme: const IconThemeData().copyWith(
              color: Colors.white,
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
          useMaterial3: true,
        ),
        home: const AuthOrAppPage(),
      ),
    );
  }
}
