import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:meow_meow/bloc/base_bloc.dart';
import 'package:meow_meow/bloc/base_state.dart';
import 'package:meow_meow/model/message_model.dart';

class MessageBloc extends BaseBloc {
  MessageState currentState;
  String userId = "";

  MessageBloc(this.currentState);

  void setId(String id) {
    this.userId = id;
  }

  final _streamMessage = StreamController<MessageState>.broadcast();

  Stream<MessageState> get stream => _streamMessage.stream;

  void addMessage(String message) {
    MessageModel msg = new MessageModel();
    msg.message = message;
    msg.userId = userId;
    currentState.addMessage(msg);
    _streamMessage.sink.add(currentState);
  }

  @override
  void dispose() {
    _streamMessage?.close();
  }
}

class MessageState extends BaseState {
  List<MessageModel> messages;

  List<MessageModel> get listMessage => messages ?? new List<MessageModel>();

  void addMessage(MessageModel msg) {
    if (messages == null) {
      messages = new List();
    }
    messages.insert(0, msg);
  }
}
