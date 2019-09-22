import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meow_meow/constant/helper.dart';

class EncodeText extends StatefulWidget {
  String text;
  String encodeText;
  TextStyle style;
  bool own;
  Key key;

  EncodeText(
    this.text, {
    this.style,
    this.key,
    this.own = true,
  }) {
    this.encodeText = Helper.encode(text);
  }

  @override
  State<StatefulWidget> createState() {
    return EncodeTextState();
  }
}

class EncodeTextState extends State<EncodeText> {
  String displayText = "";

  @override
  void initState() {
    super.initState();
    displayText = widget.encodeText;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: Container(
            padding: EdgeInsets.only(left: 5.0),
            child: Text(
              displayText,
              style: widget.style,
              key: widget.key,
            ),
          ),
        ),
        GestureDetector(
          onPanDown: (detail) {
            setState(() {
              displayText = widget.text;
            });
          },
          onPanEnd: (d) {
            setState(() {
              displayText = widget.encodeText;
            });
          },
          onPanCancel: () {
            setState(() {
              displayText = widget.encodeText;
            });
          },
          child: Container(
            margin: EdgeInsets.only(left: 20.0),
            child: Icon(
              Icons.adjust,
              size: 20.0,
              color: widget.own ? Colors.white : Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
