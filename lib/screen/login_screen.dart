import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:meow_meow/bloc/login_bloc/login_bloc.dart';
import 'package:meow_meow/constant/routes.dart';
import 'package:meow_meow/model/user_model.dart';
import 'package:meow_meow/screen/chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<LoginScreen> with TickerProviderStateMixin {
  final LoginBloc bloc = new LoginBloc();

  // controller
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passController = new TextEditingController();
  AnimationController _animationController;
  Animation<double> _animation;

  String _result = "result";

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 50.0,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Username",
                ),
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
            Container(
              height: 50.0,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: TextField(
                controller: _passController,
                obscureText: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Password",
                ),
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
            GestureDetector(
              onTap: () {
                _animationController.forward();
                _signIn();
              },
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Container(
                    height: 50.0,
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                _animationController.forward();
              },
              child: Container(
//              padding: EdgeInsets.symmetric(horizontal: 15.0),
                margin: EdgeInsets.only(top: 5.0),
                child: Container(
                  height: 50.0,
                  width: 10000.0,
                  child: Center(
                    child: StreamBuilder<UserModel>(
                      stream: bloc.streamUserInfo,
                      builder: (context, snapshot) {
                        if (snapshot == null || snapshot.data == null) {
                          return Center();
                        }
                        _animationController.reverse();
                        return Text(
                          snapshot.data.displayName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    FirebaseUser user;
    try {
      user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: _emailController.text, password: _passController.text))
          .user;
    } catch (e) {
      print(e.toString());
    } finally {
      if (user != null) {
        bloc.saveSharePref(user.uid);
        Navigator.of(context).popAndPushNamed(Routes.CHAT, arguments: user.uid);
//        Firestore.instance
//            .collection('user')
//            .document(user.uid)
//            .snapshots()
//            .listen((data) {
//          UserModel userModel = UserModel.fromJson(data.data);
//          bloc.fetchUserInfo(userModel);
//          Navigator.push(
//            context,
//            MaterialPageRoute(
//              builder: (BuildContext context) {
//                return ChatScreen();
//              },
//              settings: RouteSettings(
//                arguments: user.uid,
//                isInitialRoute: true,
//              ),
//            ),
//          );
//          return userModel;
//        });
//        Navigator.of(context).popAndPushNamed(Routes.CHAT, arguments: user.uid);
      } else {
        _animationController.reverse();
        setState(() {
          _result = "Fail";
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    bloc.dispose();
    super.dispose();
  }
}
