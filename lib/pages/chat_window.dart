import 'dart:convert';

import 'package:chat/db/db.dart';
import 'package:chat/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../bloc.dart';
import '../common.dart';
import '../models/chat_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../globals.dart' as globals;

class ChatWindow extends StatefulWidget {
  final UserModel friend;
  ChatWindow({this.friend});
  @override
  _ChatWindow createState() {
    return new _ChatWindow(friend);
  }
}

class _ChatWindow extends State<ChatWindow> {

  final UserModel friend;
  _ChatWindow(this.friend);
  final inputMessage = new TextEditingController();
  List<ChatModel> chatData = [];
  ScrollController _scrollController = new ScrollController();
  IO.Socket socket;
  UserModel currentUser= globals.currentUser;
  void _sendMyMessage() {
    final String text = inputMessage.text;
    if (text.isNotEmpty) {
      final messageText = new ChatModel(
          senderId: currentUser.userId,
          receiverId: friend.userId,
          text: text,
          sendingTime: DateTime.now().toString(),
          receiveTime: '',
          mediaUrl: '',
          isSent: 0,
          isReceived: 0);

    //  if (friend.socketId != null) {
        var payload = {
          "text": text,
          "to": friend.socketId,
          "from": currentUser.socketId,
          "senderId": currentUser.userId,
          "receiverId": friend.userId
        };
        socket.emitWithAck('privateMessage', jsonEncode(payload) , ack: (data) {
         messageText.isSent=1;
          DBProvider.db.addChat(messageText).then((data) {
            if (data != null) {
            } else {}
          });
        });
     // }

      inputMessage.text = '';
      _scrollController.animateTo(
        _scrollController.offset + 300,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: inputMessage,
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () => _sendMyMessage(),
          ),
        ],
      ),
    );
  }

  _buildMessage(ChatModel chat) {
    final bool isMe = currentUser.userId == chat.senderId;
    final backColor = isMe ? Theme.of(context).primaryColorLight : Colors.white;
    return Column(
      children: <Widget>[
        Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: backColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 2,
                    color: Color(0x22000000),
                    offset: Offset(1, 2),
                  ),
                ],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: chat.text,
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
                        ),
                        TextSpan(
                          text: '3:16 PM',
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 12.0,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ),
                Icon(
                  Icons.check,
                  color: Color(0xFF7ABAF4),
                  size: 16,
                )
              ])),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Bloc bloc = BlocProvider.of(context);
   bloc.receivedMessage.listen((event) {
      print('starge');
      ChatModel receivedTxt =    ChatModel.fromJson(jsonDecode(event));

      if(receivedTxt.senderId == friend.userId){
        chatData.add(receivedTxt);
       /* setState((){
          chatData=chatData;
          print(123);
        }); */  
      }
    });
 
    bloc.socket.listen((event) {
      socket = event;
      print(event);
    });

    

    return new Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: new Text(friend.name),
          elevation: 0.0,
          actions: <Widget>[
            new Icon(Icons.videocam),
            new Padding(padding: const EdgeInsets.symmetric(horizontal: 6)),
            new Icon(Icons.call),
            new Padding(padding: const EdgeInsets.symmetric(horizontal: 2)),
            new Icon(Icons.more_vert)
          ],
        ),
        body: GestureDetector(
          child: Column(
            children: <Widget>[
              Expanded(
                child: new Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    child: ListView.builder(
                        reverse: false,
                        controller: _scrollController,
                        padding: const EdgeInsets.only(top: 15),
                        itemCount: chatData?.length??0,
                        itemBuilder: (BuildContext context, int i) {
                          return _buildMessage(chatData[i]);
                        }),
                  ),
                ),
              ),
              _buildMessageComposer()
            ],
          ),
        ));
  }
}
