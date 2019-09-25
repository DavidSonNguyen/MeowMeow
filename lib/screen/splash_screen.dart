import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:meow_meow/constant/routes.dart';
import 'package:meow_meow/resource/drawable.dart';
import 'package:meow_meow/screen/chat_screen.dart';
import 'package:meow_meow/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _checkLogin();
    super.initState();
  }

  void _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = prefs.getString("uuid");
    if (uuid == null || uuid.isEmpty) {
      // chưa login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return LoginScreen();
          },
          settings: RouteSettings(
            isInitialRoute: true,
          ),
        ),
      );
    } else {
      // login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return ChatScreen();
          },
          settings: RouteSettings(
            arguments: uuid,
            isInitialRoute: true,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
//        child: Image.asset(Drawable.splash, fit: BoxFit.fill,),
          ),
    );
  }
}
