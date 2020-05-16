import 'dart:async';

import 'package:rxdart/rxdart.dart';

class Bloc {
  final _friends = StreamController<dynamic>.broadcast();
  final BehaviorSubject _socket = BehaviorSubject<dynamic>();
  final   _text1 = PublishSubject<dynamic>();
 // Function(String) get changeFriends => _friends.sink.add;
  // Function(String) get changePassword => _password.sink.add;
  setFriends(friends){
    _friends.sink.add(friends);
  }
  setSocket(socket){
    _socket.add(socket);
  }

  setText(message){
   _text1.add(message);
  }
  
  Stream<dynamic> get friends => _friends.stream;
  Stream<dynamic> get socket => _socket.stream;
   Stream<dynamic> get receivedMessage => _text1.stream;


   

  void destroy(){
    _friends.close();
    _socket.close();
    _text1.close();
    // _password.close();
  }
}


final bloc = new Bloc();