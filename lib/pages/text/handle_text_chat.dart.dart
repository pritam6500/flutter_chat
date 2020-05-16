import 'package:flutter/material.dart';

class ChatBubbleTriangle extends CustomPainter {
  Color colorCode;
  ChatBubbleTriangle(this.colorCode);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = colorCode;

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

