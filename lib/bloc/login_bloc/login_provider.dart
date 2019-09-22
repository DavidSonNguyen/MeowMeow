import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:meow_meow/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider {
  Future<FirebaseUser> signIn(String email, String pass) async {
    FirebaseUser user;
    try {
      user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: pass))
          .user;

      return user;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<UserModel> fetchUserInfo(String uuid) async {

    return null;
  }
}
