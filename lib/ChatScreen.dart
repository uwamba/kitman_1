import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/ChatModel.dart';
import 'model/Message.dart';
import 'model/User.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';

class ChatScreen extends StatefulWidget {
  final User user;
  final ChatModel chatModel;

  ChatScreen({this.user, this.chatModel});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  _buildMessage(Message message, bool isMe) {
    double radius = ConstantWidget.getScreenPercentSize(context, 2.2);
    double horizontal = ConstantWidget.getScreenPercentSize(context, 2);
    double vertical = ConstantWidget.getScreenPercentSize(context, 2);
    double left = ConstantWidget.getWidthPercentSize(context, 20);
    double bottom = ConstantWidget.getScreenPercentSize(context, 1);
    double top = ConstantWidget.getScreenPercentSize(context, 0.8);

    final Container msg = Container(
      width: MediaQuery.of(context).size.width * 0.75,
      margin: isMe
          ? EdgeInsets.only(top: top, bottom: bottom, left: left)
          : EdgeInsets.only(top: bottom, bottom: bottom),
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      decoration: isMe
          ? BoxDecoration(
              color: "#52575C".toColor(),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  bottomLeft: Radius.circular(radius),
                  topRight: Radius.circular(radius)))
          : BoxDecoration(
              color: ConstantData.cellColor,
              // color: Color(0xFFe4f1fe),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  topRight: Radius.circular(radius),
                  bottomRight: Radius.circular(radius))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.time,
            style: TextStyle(
                color: isMe ? Colors.white : ConstantData.mainTextColor,
                fontSize: 13.0,
                fontWeight: FontWeight.w600),
          ),
          // SizedBox(
          //   height: 8.0,
          // ),
          // Text(message.text,
          //     style: TextStyle(
          //         color: isMe ? Colors.white : ConstantData.mainTextColor,
          //         fontSize: 13.0,
          //         fontWeight: FontWeight.w600)),

          Text(message.text,
              style: TextStyle(
                  height: 1.5,
                  color: isMe ? Colors.white : ConstantData.mainTextColor,
                  fontSize: ConstantWidget.getScreenPercentSize(context, 2),
                  fontWeight: FontWeight.w600))
        ],
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
      ],
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: ConstantData.cellColor,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: ConstantData.mainTextColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              style: TextStyle(
                  color: ConstantData.mainTextColor,
                  fontFamily: ConstantData.fontFamily,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                  hintText: 'Send a message..',
                  hintStyle: TextStyle(
                      color: ConstantData.textColor,
                      fontFamily: ConstantData.fontFamily,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w500)),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: ConstantData.mainTextColor,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = ConstantWidget.getScreenPercentSize(context, 5.5);
    double padding = ConstantWidget.getScreenPercentSize(context, 1.5);
    return WillPopScope(
        child: Scaffold(
            backgroundColor: ConstantData.bgColor,
            body: SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: ConstantWidget.getScreenPercentSize(context, 3.1),
                    ),

                    Row(
                      children: [
                        SizedBox(
                          width:
                              ConstantWidget.getWidthPercentSize(context, 1.8),
                        ),
                        IconButton(
                          icon: Icon(Icons.keyboard_backspace_outlined),
                          color: ConstantData.mainTextColor,
                          onPressed: () {
                            finish();
                          },
                        ),
                        SizedBox(
                          width: ConstantWidget.getWidthPercentSize(context, 1),
                        ),
                        Container(
                          height: imageSize,
                          width: imageSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: ExactAssetImage(
                                  ConstantData.assetsPath + "hugh.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width:
                              ConstantWidget.getWidthPercentSize(context, 1.5),
                        ),
                        ConstantWidget.getCustomTextWithoutAlign(
                            (widget.chatModel != null)
                                ? widget.chatModel.name
                                : widget.user.name,
                            ConstantData.mainTextColor,
                            FontWeight.bold,
                            ConstantData.font22Px),
                      ],
                    ),

                    Expanded(
                        child: Container(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: ListView.builder(
                          reverse: true,
                          padding: EdgeInsets.only(top: padding),
                          itemCount: messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Message message = messages[index];
                            final bool isMe =
                                message.sender.id == currentUser.id;
                            return _buildMessage(message, isMe);
                          }),
                    )),
                    // ),
                    _buildMessageComposer(),
                  ],
                ),
              ),
            )),
        onWillPop: () async {
          finish();
          return false;
        });
  }

  void finish() {
    Navigator.of(context).pop();
  }
}
