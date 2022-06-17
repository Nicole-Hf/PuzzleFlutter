import 'package:flutter/material.dart';
import 'package:puzzle_kids/models/imagebox_model.dart';
import 'package:puzzle_kids/models/puzzlepos_model.dart';

class JigsawBlockPainter extends CustomPainter {
  ImageBox imageBox;
  JigsawBlockPainter({required this.imageBox});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
    ..color = imageBox.isDone 
      ? Colors.white.withOpacity(0.2) : Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

    canvas.drawPath(getPiecePath1(size, imageBox.radiusPoint, 
      imageBox.offsetCenter,
      imageBox.posSide), paint);
    
    if (imageBox.isDone) {
      Paint paintDone = Paint()
        ..color = Colors.white.withOpacity(0.2)
        ..style = PaintingStyle.fill
        ..strokeWidth = 2;

      canvas.drawPath(
        getPiecePath1(size, imageBox.radiusPoint, 
          imageBox.offsetCenter,
          imageBox.posSide), paintDone);
    }
  }

  @override
  bool shouldRepaint(JigsawBlockPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(JigsawBlockPainter oldDelegate) => false;
}

getPiecePath1(Size size, double radiusPoint, Offset offsetCenter, ClassJigsawPos posSide) {
  Path path = Path();

  Offset topLeft = const Offset(0, 0);
  Offset topRight = Offset(size.width, 0);
  Offset bottomLeft = Offset(0, size.height);
  Offset bottomRight = Offset(size.width, size.height);

  topLeft = Offset(posSide.left > 0 ? radiusPoint : 0, 
    (posSide.top > 0) ? radiusPoint : 0) + topLeft;
  topRight = Offset(posSide.rigth > 0 ? -radiusPoint : 0, 
    (posSide.top > 0) ? radiusPoint : 0) + topRight;
  bottomRight = Offset(posSide.rigth > 0 ? -radiusPoint : 0, 
    (posSide.bottom > 0) ? -radiusPoint : 0) + bottomRight;
  bottomLeft = Offset(posSide.left > 0 ? radiusPoint : 0, 
    (posSide.bottom > 0) ? -radiusPoint : 0) + bottomLeft;

  double topMiddle = posSide.top == 0 ? topRight.dy 
    : (posSide.top > 0 ? topRight.dy - radiusPoint : topRight.dy + radiusPoint);
  
  double bottomMiddle = posSide.bottom == 0 ? bottomRight.dy 
    : (posSide.bottom > 0 ? bottomRight.dy + radiusPoint : bottomRight.dy - radiusPoint);

  double leftMiddle = posSide.left == 0 ? topLeft.dx 
    : (posSide.left > 0 ? topLeft.dx - radiusPoint : topLeft.dx + radiusPoint);

  double rightMiddle = posSide.rigth == 0 ? topRight.dx 
    : (posSide.rigth > 0 ? topRight.dx + radiusPoint : topRight.dx - radiusPoint);

  path.moveTo(topLeft.dx, topLeft.dy);

  if (posSide.top != 0) {
    path.extendWithPath(
      calculatePoint(Axis.horizontal, topLeft.dy, 
        Offset(offsetCenter.dx, topMiddle), radiusPoint), Offset.zero);
  }
  path.lineTo(topRight.dx, topRight.dy);
  if (posSide.rigth != 0) {
    path.extendWithPath(
      calculatePoint(Axis.vertical, topRight.dx, 
        Offset(rightMiddle, offsetCenter.dy), radiusPoint), Offset.zero);
  }
  path.lineTo(bottomRight.dx, bottomRight.dy);
  if (posSide.bottom != 0) {
    path.extendWithPath(
      calculatePoint(Axis.horizontal, bottomRight.dy, 
        Offset(offsetCenter.dx, bottomMiddle), -radiusPoint), Offset.zero);
  }
  path.lineTo(bottomLeft.dx, bottomLeft.dy);
  if (posSide.left != 0) {
    path.extendWithPath(
      calculatePoint(Axis.vertical, bottomLeft.dx, 
        Offset(leftMiddle, offsetCenter.dy), -radiusPoint), Offset.zero);
  }
  path.lineTo(topLeft.dx, topLeft.dy);

  path.close();

  return path;
}

calculatePoint(Axis axis, double fromPoint, Offset point, double radiusPoint) {
  Path path = Path();

  if (axis == Axis.horizontal) {
    path.moveTo(point.dx - radiusPoint / 2, fromPoint);
    path.lineTo(point.dx - radiusPoint / 2, point.dy);
    path.lineTo(point.dx + radiusPoint / 2, point.dy);
    path.lineTo(point.dx + radiusPoint / 2, fromPoint);
  } else if (axis == Axis.vertical) {
    path.moveTo(fromPoint, point.dy - radiusPoint / 2);
    path.lineTo(point.dx, point.dy - radiusPoint / 2);
    path.lineTo(point.dx, point.dy + radiusPoint / 2);
    path.lineTo(fromPoint, point.dy + radiusPoint / 2);
  }

  return path;
}