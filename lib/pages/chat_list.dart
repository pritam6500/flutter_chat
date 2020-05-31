import 'package:flutter/material.dart';
import '../bloc.dart';
import '../common.dart';
import '../models/user_model.dart';
import 'chat_window.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() {
    return new _ChatState();
  }
}

getColor(s){
  if(s !=null && s!= ""){
    return Colors.green;
  }else{
    return Colors.grey;
  }
 
}

class _ChatState extends State<Chat> {
  List<UserModel> friends;

  Widget buildFriendList(UserModel friend){
      return new Column(children: <Widget>[
          new Divider(height: 10),
          new ListTile(
            leading: new CircleAvatar(
              foregroundColor: Theme.of(context).primaryColor,
              backgroundColor: getColor(friend.socketId) ,
              // backgroundImage: new NetworkImage(friends[i].avatarUrl),
            ),
            title: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    friend.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  new Text(
                    '12.30',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
                  )
                ]),
            subtitle: new Container(
              padding: const EdgeInsets.only(top: 0.5),
              child: new Text(
                'abc xyz ok bla ',
                style: new TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
            onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChatWindow(friend: friend))),
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
  final Bloc bloc = BlocProvider.of(context);
    return StreamBuilder(
      stream: bloc.friends,
      builder: (context, snapshot){
            friends=snapshot.data;        
            return ListView.builder(
              itemCount: friends?.length ?? 0,
              itemBuilder:(context,i){
                return buildFriendList(friends[i]); 
              }); 
            
    });
  }
}



/*

 ListView.builder(
    itemCount: friends?.length ?? 0,
    itemBuilder: (context, i) => new Column(children: <Widget>[
          new Divider(height: 10),
          new ListTile(
            leading: new CircleAvatar(
              foregroundColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey,
              // backgroundImage: new NetworkImage(friends[i].avatarUrl),
            ),
            title: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    friends[i].name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  new Text(
                    '12.30',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
                  )
                ]),
            subtitle: new Container(
              padding: const EdgeInsets.only(top: 0.5),
              child: new Text(
                'abc xyz ok bla ',
                style: new TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
            onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChatWindow(friend: friends[i]))),
          )
        ]));
*/