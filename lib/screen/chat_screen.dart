import 'package:flutter/material.dart';
import 'package:meow_meow/bloc/login_bloc/message_bloc.dart';
import 'package:meow_meow/model/message_model.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _emailController = new TextEditingController();
  final MessageBloc _msgBloc = new MessageBloc(new MessageState());

  @override
  Widget build(BuildContext context) {
    final uuid = ModalRoute.of(context).settings.arguments;
    _msgBloc.setId(uuid);
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 5.0).copyWith(bottom: 5.0),
                child: StreamBuilder<MessageState>(
                  stream: _msgBloc.stream,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Center();
                    }
                    List<MessageModel> listMessage = snapshot.data.messages;
                    return ListView.builder(
                      reverse: true,
                      itemCount: listMessage.length,
                      itemBuilder: (context, index) {
                        MessageModel m = listMessage[index];
                        if (m == null) {
                          return Center();
                        }
                        return Row(
                          mainAxisAlignment: m.userId != _msgBloc.userId
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(3.0),
                              margin: EdgeInsets.symmetric(vertical: 2.0),
                              child: Text(
                                "${m.message}",
                                style: TextStyle(
                                    color: m.userId == _msgBloc.userId
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              decoration: BoxDecoration(
                                color:
                                m.userId == _msgBloc.userId ? Colors.blue : Colors.white,
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextField(
                        controller: _emailController,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Message",
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _msgBloc.addMessage(_emailController.text);
                      _emailController.clear();
                    },
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      margin: EdgeInsets.only(left: 5.0),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.blue,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
