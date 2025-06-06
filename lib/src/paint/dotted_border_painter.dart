import 'package:flutter/material.dart';

enum DottedLineType { dot, dash }

class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double spacing;
  final double radius;
  final double borderRadius;
  final DottedLineType lineType;

  DottedBorderPainter({
    this.color = Colors.black,
    this.strokeWidth = 1.0,
    this.spacing = 4.0,
    this.radius = 4.0,
    this.borderRadius = 12.0,
    this.lineType = DottedLineType.dash,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = lineType == DottedLineType.dot
          ? PaintingStyle.fill
          : PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);
    final pathMetrics = path.computeMetrics();

    for (final metric in pathMetrics) {
      double distance = 0.0;

      while (distance < metric.length) {
        final pos = metric.getTangentForOffset(distance);
        if (pos != null) {
          if (lineType == DottedLineType.dot) {
            canvas.drawCircle(pos.position, radius, paint);
            distance += spacing;
          } else if (lineType == DottedLineType.dash) {
            final endDistance = distance + radius;
            if (endDistance < metric.length) {
              final next = metric.getTangentForOffset(endDistance);
              if (next != null) {
                canvas.drawLine(pos.position, next.position, paint);
              }
            }
            distance += radius + spacing;
          }
        } else {
          break;
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
