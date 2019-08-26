import 'package:flutter/material.dart';
import 'package:meow_meow/screen/login_screen.dart';

import 'constant/routes.dart';
import 'screen/chat_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        Routes.LOGIN: (context) => LoginScreen(),
        Routes.CHAT: (context) => ChatScreen(),
      },
      initialRoute: Routes.LOGIN,
    );
  }
}
