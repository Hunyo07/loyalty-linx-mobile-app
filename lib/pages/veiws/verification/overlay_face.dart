import 'package:flutter/material.dart';

class OverlayPainterFace extends CustomPainter {
  final double screenWidth;
  final double screenHeight;

  OverlayPainterFace({required this.screenWidth, required this.screenHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final width = screenWidth * 0.90;
    final height = screenHeight * 0.50;
    const borderRadius = 160.0;
    const strokeWidth = 2.0;
    final rectanglePath = Path()
      ..addRRect(RRect.fromLTRBR(
        (screenWidth - width) / 2,
        20,
        (screenWidth + width) / 2,
        height,
        const Radius.circular(borderRadius),
      ));

    final outerPath = Path()
      ..addRRect(RRect.fromLTRBR(
          0, 0, screenWidth, screenHeight, const Radius.circular(0)));
    final overlayPath =
        Path.combine(PathOperation.difference, outerPath, rectanglePath);

    final paint = Paint()
      ..color = const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawPath(overlayPath, paint);
    canvas.drawRRect(
      RRect.fromLTRBR(
        (screenWidth - width) / 2,
        20,
        (screenWidth + width) / 2,
        height,
        const Radius.circular(borderRadius),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
