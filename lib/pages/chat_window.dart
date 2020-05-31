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
  UserModel currentUser = globals.currentUser;
  Bloc bloc;
  List<ChatModel> chats = [];
   
  void initState() {
    super.initState();
    loadPreviousChats();
  } 

  void loadPreviousChats(){
      DBProvider.db.getChats(friend.userId.toString()).then((chats) {
        chats.addAll(chats);  
      });
  }

  void _sendMyMessage() async {
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

      var payload = {
        "text": text,
        "to": friend.socketId,
        "from": currentUser.socketId,
        "senderId": currentUser.userId,
        "receiverId": friend.userId
      };

      var savedData = await DBProvider.db.addChat(messageText);
      if (savedData != null) {
        inputMessage.text = '';
        bloc.setText(jsonEncode(payload));
        if (friend.socketId != null && socket != null) {
          socket.emit('privateMessage', jsonEncode(payload));
          print(savedData);
          print(123);
        }
      }else{
          print('something wrong..need error handling');
      }

      /* _scrollController.animateTo(
        _scrollController.offset + 300,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      ); */
    }
  }

  Widget  _buildMessageComposer() {
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

  Widget _buildMessage(ChatModel chat) {
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

  Widget _chatWrapper() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      child: StreamBuilder(
          stream: bloc.receivedMessage,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              ChatModel chat = ChatModel.fromJson(jsonDecode(snapshot.data));
              chats.add(chat);
              return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    return _buildMessage(chats[index]);
                  });
            } else {
              return Container();
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<Bloc>(context);
    bloc.socket.listen((event) {
      socket = event;
    });

    return new Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          titleSpacing: 0,
          title: ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: CircleAvatar(
              // backgroundImage: NetworkImage(conversation.image),
              backgroundColor: Colors.red,
            ),
            title: Text(
              friend.name,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            subtitle: Text(
              friend.socketId != null ? 'Online' : '',
              style: TextStyle(color: Colors.white.withOpacity(.7)),
            ),
          ),
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
                  child: _chatWrapper(),
                ),
              ),
              _buildMessageComposer()
            ],
          ),
        ));
  }
}
