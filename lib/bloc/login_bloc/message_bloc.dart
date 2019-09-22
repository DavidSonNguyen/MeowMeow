import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:meow_meow/bloc/base_bloc.dart';
import 'package:meow_meow/bloc/base_state.dart';
import 'package:meow_meow/model/message_model.dart';
import 'package:meow_meow/model/user_model.dart';

class MessageBloc extends BaseBloc {
  MessageState currentState;
  String userId = "";

  MessageBloc(this.currentState);

  void setId(String id) {
    this.userId = id;
  }

  final _streamMessage = StreamController<MessageState>.broadcast();

  Stream<MessageState> get stream => _streamMessage.stream;

  void addMessage(String message) async {
//    int nextIndex = currentState.listMessage.length;
    MessageModel msg = new MessageModel();
    msg.message = message;
    msg.userId = userId;
    msg.id = "${new DateTime.now().millisecondsSinceEpoch}";
//    currentState.addMessage(msg);
//    _streamMessage.sink.add(currentState);
    msg.status = "sent";
    Firestore.instance
        .collection("message")
        .document(msg.id)
        .setData(msg.toJson());
  }

  void fetchMessage() async {
    Firestore.instance.collection("message").snapshots().listen((data) {
      if (data.documentChanges == null || data.documentChanges.isEmpty) {
        if (data.documents == null) {
          return;
        }
        List<DocumentSnapshot> initMsg = data.documents;
        for (DocumentSnapshot ds in initMsg) {
          currentState.addMessage(MessageModel.fromJson(ds.data));
        }
      } else {
        List<DocumentChange> doc = data.documentChanges;
        for (DocumentChange ds in doc) {
          currentState.addMessage(MessageModel.fromJson(ds.document.data));
        }
      }
      _streamMessage.add(currentState);
    });
  }

  void fetchUserInfo(String uuid) async {
    Firestore.instance
        .collection("user")
        .document(uuid)
        .snapshots()
        .listen((data) {
      if (data != null) {
        UserModel model = UserModel.fromJson(data.data);
        currentState.userModel = model;
      }
    });
  }

  void saveSharePref(String uuid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("uuid", uuid);
    prefs.getString("uuid");
  }

  @override
  void dispose() {
    _streamMessage?.close();
  }
}

class MessageState extends BaseState {
  List<MessageModel> messages;
  UserModel userModel;

  List<MessageModel> get listMessage => messages ?? new List<MessageModel>();

  void addMessage(MessageModel msg, [bool last = false]) {
    if (messages == null) {
      messages = new List();
    }
    last ? messages.add(msg) : messages.insert(0, msg);
  }

  void set msg(List<MessageModel> list) {
    this.messages = list;
  }
}
