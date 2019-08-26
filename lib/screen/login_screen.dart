import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meow_meow/constant/routes.dart';
import 'package:meow_meow/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<LoginScreen> {
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passController = new TextEditingController();

  String _result = "result";

  @override
  void initState() {
    super.initState();
    _checkLogin();
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
//RaisedButton(onPressed: () {}, )
            GestureDetector(
              onTap: () {
                _signIn();
              },
              child: Container(
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
              ),
            ),
            Container(
              height: 50.0,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              margin: EdgeInsets.only(top: 5.0),
              child: Center(
                child: Text(
                  _result,
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
            )
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
        _getUserInfo(user.uid);
      } else {
        setState(() {
          _result = "Fail";
        });
      }
    }
  }

  void _getUserInfo(String uuid) {
    Firestore.instance
        .collection('user')
        .document(uuid)
        .snapshots()
        .listen((data) {
      UserModel userModel = UserModel.fromJson(data.data);
      _saveSharePref(userModel);
      setState(() {
        _result = userModel.displayName;
      });
    });
  }

  void _saveSharePref(UserModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("uuid", model.uuid);
    prefs.getString("uuid");
  }

  void _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = prefs.getString("uuid");
    if (uuid == null || uuid.isEmpty) {
      // chưa login
    } else {
      // login
      Navigator.of(context).pushNamed(Routes.CHAT);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }
}
