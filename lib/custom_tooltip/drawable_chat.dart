import 'package:flutter/material.dart';

class CustomTooltipsBackground extends StatelessWidget {
  const CustomTooltipsBackground({required this.text, this.textStyle, required this.color, super.key});
  final String text;
  final TextStyle? textStyle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TooltipPainter(color: color),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
        child: Text(
          text,
          style: textStyle,
        ),
      ),

    );
  }
}

class TooltipPainter extends CustomPainter {
  final Color color;
  final double radius;

  TooltipPainter({required this.color, this.radius=5.0});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;

    // Path for tooltip shape
    final Path path = Path()
      ..moveTo(radius, 0) // Start at top-left corner
      ..lineTo(size.width - radius, 0) // Draw top edge
      ..quadraticBezierTo(size.width, 0, size.width, radius) // Top-right curve
      ..lineTo(size.width, size.height - (10+radius)) // Right edge
      ..quadraticBezierTo(size.width, size.height - 10, size.width - radius,
          size.height - 10) // Bottom-right curve
      ..lineTo(size.width / 2 + 8, size.height - 10) // Horizontal to arrow
      ..lineTo(size.width / 2, size.height) // Arrow point
      ..lineTo(size.width / 2 - 8, size.height - 10) // Horizontal from arrow
      ..lineTo(radius, size.height - 10) // Bottom-left horizontal
      ..quadraticBezierTo(0, size.height - 10, 0, size.height - (10+radius)) // Bottom-left curve
      ..lineTo(0, radius) // Left edge
      ..quadraticBezierTo(0, 0, radius, 0) // Top-left curve
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
