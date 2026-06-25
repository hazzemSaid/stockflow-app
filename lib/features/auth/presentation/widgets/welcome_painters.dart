import 'package:flutter/material.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';

class DecorativeCirclesPainter extends CustomPainter {
  const DecorativeCirclesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paintOrange = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final paintWhite = Paint()
      ..color = AppColors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(w * 0.76, h * 0.16), w * 0.184, paintOrange);
    canvas.drawCircle(Offset(w * 0.16, h * 0.75), w * 0.132, paintWhite);
    canvas.drawCircle(Offset(w * 0.17, h * 0.36), w * 0.066, paintOrange);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StockIconPainter extends CustomPainter {
  const StockIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSizes.strokeWidthIcon
      ..strokeCap = StrokeCap.round;

    final l = size.width;
    final t = size.height;

    canvas.drawRect(
      Rect.fromLTRB(l * 0.083, t * 0.132, l * 0.917, t * 0.917),
      paint,
    );

    canvas.drawLine(
      Offset(l * 0.25, t * 0.75),
      Offset(l * 0.75, t * 0.75),
      paint,
    );

    canvas.drawLine(
      Offset(l * 0.25, t * 0.583),
      Offset(l * 0.75, t * 0.583),
      paint,
    );

    canvas.drawLine(
      Offset(l * 0.25, t * 0.417),
      Offset(l * 0.75, t * 0.417),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

