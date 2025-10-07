import 'package:flutter/material.dart';

class BubbleIndicatorPainter extends CustomPainter {
  final PageController pageController;

  BubbleIndicatorPainter({required this.pageController});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    double page = 0.0;
    if (pageController.hasClients && pageController.page != null) {
      page = pageController.page!;
    }

    double dx = (size.width / 2) * (1 + page);
    canvas.drawCircle(Offset(dx, size.height / 2), size.height / 2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}