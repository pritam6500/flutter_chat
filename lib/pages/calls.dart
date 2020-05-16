import 'package:flutter/material.dart';
class Calls extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return   MaterialApp(
      home: Padding(
        padding: EdgeInsets.all(7),
        child: 
        
        Align(
          alignment: Alignment.centerRight,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xFF486993),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'This is telegram message   ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0
                            ),
                          ),
                          TextSpan(
                            text: '3:16 PM',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                                fontStyle: FontStyle.italic
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.check, color: Color(0xFF7ABAF4), size: 16,)
                  ]
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CustomPaint(
                  painter: ChatBubbleTriangle(),
                )
              )
            ]
          )
        ),
      ),
    );
  }
  
}



class ChatBubbleTriangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Color(0xFF486993);

    var path = Path();
    path.lineTo(-15, 0);
    path.lineTo(0, -15);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}