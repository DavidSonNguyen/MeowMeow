import 'package:flutter/material.dart';
import 'package:meow_meow/screen/login_screen.dart';
import 'package:provider/provider.dart';
import 'bloc/global_provider.dart';
import 'constant/routes.dart';
import 'screen/chat_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalProvider>(
          builder: (context) => GlobalProvider(),
        ),
      ],
      child: Consumer<GlobalProvider>(
        builder: (context, provider, _) {
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
        },
      ),
    );
  }
}
