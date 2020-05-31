import 'dart:async';

import 'package:rxdart/rxdart.dart';

import './common.dart';

class Bloc extends BlocBase {
  StreamController _friends = StreamController<dynamic>.broadcast();
  BehaviorSubject _socket = BehaviorSubject<dynamic>();
  StreamController _text1 = StreamController<dynamic>.broadcast();


  setFriends(friends) {
    _friends.sink.add(friends);
  }

  setSocket(socket) {
    _socket.add(socket);
  }

  setText(message) {
    _text1.sink.add(message);
  }

  Stream<dynamic> get friends => _friends.stream;
  Stream<dynamic> get socket => _socket.stream;
  Stream<dynamic> get receivedMessage => _text1.stream;

  @override
  void dispose() {
    _friends.close();
   // _socket.close();
    _text1.close();
  }
}
