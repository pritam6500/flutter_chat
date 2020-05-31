import 'dart:async';
import 'package:chat/pages/calls.dart';
import 'package:chat/pages/camera.dart';
import 'package:chat/pages/chat_list.dart';
import 'package:chat/pages/status.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:global_configuration/global_configuration.dart';
import 'bloc.dart';
import 'common.dart';
import 'db/db.dart';
import 'models/user_model.dart';
import 'globals.dart' as globals;
class WhatsAppHome extends StatefulWidget {
  @override
  _WhatsAppHomeState createState() => new _WhatsAppHomeState();
}

class _WhatsAppHomeState extends State<WhatsAppHome>
    with SingleTickerProviderStateMixin {
  
  Bloc bloc;
  TabController _tabController;
  IO.Socket socket;
  UserModel currentUser;
  List<UserModel> friends = [];
    
  
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, initialIndex: 1, length: 4);
    if(globals.isLoggedIn){
      currentUser= globals.currentUser;
      DBProvider.db.getFriends().then((data) {
      for (var u in data) {
          friends.add(UserModel.fromJson(u));
      }
          connectSocket();
      });
    }else{
        // navigate to home
    }
    
  }

  Future connectSocket() async {
    socket = IO.io(
        GlobalConfiguration().getString("apiUrl") +
            '?userId=' +
            currentUser.userId.toString(),
        <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': true,
        });
   // socket.connect();
   // socket.io..disconnect()..connect(); 
    socket.on('connect',(_){
        bloc.setSocket(socket);
    });
    socket.on('userConnected', (data) {
      currentUser.socketId = data[currentUser.userId.toString()]['socketId'];
      updateFriends(data);
    });

    socket.on('disConnected', (data) {
      updateFriends(data);
    });

    socket.on('privateMessage',(data){
        bloc.setText(data);
    });

  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of(context);
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("WhatsApp"),
          elevation: 0.7,
          bottom: new TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              tabs: <Widget>[
                new Tab(icon: new Icon(Icons.camera_alt)),
                new Tab(text: "CHATS"),
                new Tab(text: "STATUS"),
                new Tab(text: "CALLS")
              ]),
          actions: <Widget>[
            new Icon(Icons.search),
            new Padding(padding: const EdgeInsets.symmetric(horizontal: 0.5)),
            new Icon(Icons.more_vert)
          ],
        ),
        body: new TabBarView(
          controller: _tabController,
          children: <Widget>[
            new Camera(),
            new Chat(),
            new Status(),
            new Calls()
          ],
        ),
        floatingActionButton: new FloatingActionButton(
            backgroundColor: Theme.of(context).accentColor,
            child: new Icon(Icons.message, color: Colors.white),
            onPressed: () => print("ffe")));
  }



  void updateFriends(data){
    friends.map((e) {
        if (data.containsKey(e.userId.toString())) {
          e.socketId = data[e.userId.toString()]['socketId'];
        } else {
          e.socketId = null;
        }
        return e;
      }).toList();
       bloc.setFriends(friends);
  }
}
