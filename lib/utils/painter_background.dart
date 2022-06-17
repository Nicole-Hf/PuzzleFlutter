import 'package:flutter/material.dart';
import 'package:puzzle_kids/models/block_model.dart';
import 'package:puzzle_kids/utils/block_painter_widget.dart';

class JigsawPainterBackground extends CustomPainter {
  List<BlockClass> blocks = [];
  JigsawPainterBackground(this.blocks);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black12
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    Path path = Path();

    // ignore: avoid_function_literals_in_foreach_calls
    blocks.forEach((element) {
      Path pathTemp = getPiecePath1(
        element.jigsawBlockWidget.imageBox.size,
        element.jigsawBlockWidget.imageBox.radiusPoint,
        element.jigsawBlockWidget.imageBox.offsetCenter,
        element.jigsawBlockWidget.imageBox.posSide,
      );
      path.addPath(pathTemp, element.offsetDefault);
    });
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}