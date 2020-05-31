import 'package:flutter/material.dart';

class Status extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _usersWidget(),
          _usersWidget()

        ],
      ),
    );
  }

  Widget _usersWidget() {
    return Column(children: <Widget>[
        Container(
      width: 150,
      height: 150,
      child: CircleAvatar(),
      decoration: BoxDecoration(
        color: Colors.blue,
        border: Border.all(),
      ),
    )
    ]); 
  }
}
