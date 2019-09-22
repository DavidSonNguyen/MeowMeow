import 'package:flutter/material.dart';
import 'package:meow_meow/bloc/login_bloc/message_bloc.dart';
import 'package:meow_meow/constant/helper.dart';
import 'package:meow_meow/model/message_model.dart';
import 'package:meow_meow/widget/encode_text.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _emailController = new TextEditingController();
  final MessageBloc _msgBloc = new MessageBloc(new MessageState());

  @override
  void initState() {
    _msgBloc.fetchMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final uuid = ModalRoute.of(context).settings.arguments;
    _msgBloc.setId(uuid);
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0)
                      .copyWith(bottom: 5.0),
                  child: StreamBuilder<MessageState>(
                    stream: _msgBloc.stream,
                    builder: (context, snapshot) {
                      if (snapshot.data == null ||
                          snapshot.data.listMessage == null) {
                        return Center();
                      }
                      List<MessageModel> listMessage =
                          snapshot.data.listMessage;
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
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              m.userId == _msgBloc.userId ? Container(
                                width: 80.0,
                              ) : Center(),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.all(3.0),
                                  margin: EdgeInsets.symmetric(vertical: 2.0),
                                  child: EncodeText(
                                    "${m.message}",
                                    style: TextStyle(
                                      color: m.userId == _msgBloc.userId
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    own: m.userId == _msgBloc.userId,
                                  ),
                                  decoration: BoxDecoration(
                                    color: m.userId == _msgBloc.userId
                                        ? Colors.blue
                                        : Colors.white,
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              m.userId != _msgBloc.userId ? Container(
                                width: 80.0,
                              ) : Center(),
                              m.userId == _msgBloc.userId
                                  ? Container(
                                      margin: EdgeInsets.only(left: 5.0),
                                      child: Icon(
                                        m.status == "created"
                                            ? Icons.check_circle_outline
                                            : Icons.check_circle,
                                        size: 10.0,
                                        color: index == 0
                                            ? Colors.black38
                                            : Colors.white,
                                      ),
                                    )
                                  : Center(),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 5.0).copyWith(bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextField(
                          controller: _emailController,
                          style: TextStyle(fontSize: 12.0),
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
                        width: 40.0,
                        height: 40.0,
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
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
