import 'package:flutter/material.dart';

class LinkedInLogoWidget extends StatelessWidget {
  final double size;
  final Color color;

  const LinkedInLogoWidget({super.key, required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Text(
          'in',
          style: TextStyle(
            color: color,
            fontSize: size * 0.82,
            fontWeight: FontWeight.w900,
            fontFamily: 'Inter',
            height: 0.9,
          ),
        ),
      ),
    );
  }
}

class GitHubLogoPainter extends CustomPainter {
  final Color color;

  GitHubLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final sx = size.width / 24.0;
    final sy = size.height / 24.0;

    // Start path at M12 0
    path.moveTo(12 * sx, 0 * sy);
    path.cubicTo(5.374 * sx, 0 * sy, 0 * sx, 5.373 * sy, 0 * sx, 12 * sy);
    path.cubicTo(0 * sx, 17.302 * sy, 3.438 * sx, 21.8 * sy, 8.207 * sx, 23.387 * sy);
    path.cubicTo(8.806 * sx, 23.498 * sy, 9.0 * sx, 23.126 * sy, 9.0 * sx, 22.81 * sy);
    path.lineTo(9.0 * sx, 20.576 * sy);
    path.cubicTo(5.662 * sx, 21.302 * sy, 4.967 * sx, 19.16 * sy, 4.967 * sx, 19.16 * sy);
    path.cubicTo(4.421 * sx, 17.773 * sy, 3.634 * sx, 17.404 * sy, 3.634 * sx, 17.404 * sy);
    path.cubicTo(2.545 * sx, 16.659 * sy, 3.717 * sx, 16.675 * sy, 3.717 * sx, 16.675 * sy);
    path.cubicTo(4.922 * sx, 16.759 * sy, 5.556 * sx, 17.912 * sy, 5.556 * sx, 17.912 * sy);
    path.cubicTo(6.666 * sx, 19.746 * sy, 8.363 * sx, 19.216 * sy, 9.048 * sx, 18.909 * sy);
    path.cubicTo(9.155 * sx, 18.134 * sy, 9.466 * sx, 17.604 * sy, 9.81 * sx, 17.305 * sy);
    path.cubicTo(7.145 * sx, 17.0 * sy, 4.343 * sx, 15.971 * sy, 4.343 * sx, 11.374 * sy);
    path.cubicTo(4.343 * sx, 10.063 * sy, 4.812 * sx, 8.993 * sy, 5.579 * sx, 8.153 * sy);
    path.cubicTo(5.455 * sx, 7.85 * sy, 5.044 * sx, 6.629 * sy, 5.696 * sx, 4.977 * sy);
    path.cubicTo(5.696 * sx, 4.977 * sy, 6.704 * sx, 4.655 * sy, 8.997 * sx, 6.207 * sy);
    path.cubicTo(9.954 * sx, 5.941 * sy, 10.98 * sx, 5.808 * sy, 12.0 * sx, 5.803 * sy);
    path.cubicTo(13.02 * sx, 5.808 * sy, 14.047 * sx, 5.941 * sy, 15.006 * sx, 6.207 * sy);
    path.cubicTo(17.297 * sx, 4.655 * sy, 18.303 * sx, 4.977 * sy, 18.303 * sx, 4.977 * sy);
    path.cubicTo(18.956 * sx, 6.63 * sy, 18.545 * sx, 7.851 * sy, 18.421 * sx, 8.153 * sy);
    path.cubicTo(19.191 * sx, 8.993 * sy, 19.656 * sx, 10.064 * sy, 19.656 * sx, 11.374 * sy);
    path.cubicTo(19.656 * sx, 15.983 * sy, 16.849 * sx, 16.998 * sy, 14.177 * sx, 17.295 * sy);
    path.cubicTo(14.607 * sx, 17.667 * sy, 15.0 * sx, 18.397 * sy, 15.0 * sx, 19.517 * sy);
    path.lineTo(15.0 * sx, 22.81 * sy);
    path.cubicTo(15.0 * sx, 23.129 * sy, 15.192 * sx, 23.504 * sy, 15.801 * sx, 23.386 * sy);
    path.cubicTo(20.566 * sx, 21.797 * sy, 24.0 * sx, 17.3 * sy, 24.0 * sx, 12.0 * sy);
    path.cubicTo(24.0 * sx, 5.373 * sy, 18.627 * sx, 0 * sy, 12.0 * sx, 0 * sy);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
