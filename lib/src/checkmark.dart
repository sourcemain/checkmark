import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class CheckMark extends ImplicitlyAnimatedWidget {
  const CheckMark({
    Key? key,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
    VoidCallback? onEnd,
    this.active = false,
    this.activeColor = const Color(0xff4fffad),
    this.inactiveColor = const Color(0xffe3e8ed),
    this.strokeWidth = 5,
    this.strokeJoin = StrokeJoin.round,
    this.strokeCap = StrokeCap.round,
  }) : super(
          key: key,
          duration: duration,
          curve: curve,
          onEnd: onEnd,
        );

  /// Whether to show the check mark or circle.
  /// Changing triggers animation.
  ///
  /// Defaults to false.
  final bool active;

  /// Used for the active check mark.
  final Color activeColor;

  /// Used for the inactive circle.
  final Color inactiveColor;

  /// Defaults to 5.
  final double strokeWidth;

  /// Defaults to [StrokeJoin.round].
  final StrokeJoin strokeJoin;

  /// Defaults to [StrokeCap.round].
  final StrokeCap strokeCap;

  @override
  _CheckMarkState createState() => _CheckMarkState();
}

class _CheckMarkState extends AnimatedWidgetBaseState<CheckMark> {
  Tween<double>? progress;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    final int _checkState = widget.active ? 1 : 0;

    progress = visitor(
      progress,
      _checkState.toDouble(),
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CheckMarkPainter(
        progress: progress!.evaluate(animation),
        activeColor: widget.activeColor,
        inactiveColor: widget.inactiveColor,
        strokeWidth: widget.strokeWidth,
        strokeJoin: widget.strokeJoin,
        strokeCap: widget.strokeCap,
      ),
    );
  }
}

class _CheckMarkPainter extends CustomPainter {
  _CheckMarkPainter({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    required this.strokeWidth,
    required this.strokeJoin,
    required this.strokeCap,
  });

  final double progress;
  final Color activeColor;
  final Color inactiveColor;
  final double strokeWidth;
  final StrokeJoin strokeJoin;
  final StrokeCap strokeCap;

  @override
  void paint(Canvas canvas, Size size) {
    final double side = math.min(size.width, size.height);
    final double radius = side / 2;
    const double angle1 = 290;
    const double angle2 = 45;

    final math.Point<double> origin = math.Point<double>(
      radius + radius * math.sin(angle1),
      radius - radius * math.cos(angle1),
    );
    final math.Point<double> vertex = math.Point<double>(
      side * 0.3,
      side * 0.7,
    );
    final math.Point<double> terminus = math.Point<double>(
      radius + radius * math.sin(angle2),
      radius - radius * math.cos(angle2),
    );

    final ColorTween _colorTween = ColorTween(
      begin: inactiveColor,
      end: activeColor,
    );

    final Paint paint = Paint()
      ..color = _colorTween.lerp(progress)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = strokeJoin
      ..strokeCap = strokeCap;

    final Path path = Path()
      ..moveTo(
        origin.x,
        origin.y,
      )
      ..addArc(
        Rect.fromCircle(
          center: Offset(radius, radius),
          radius: radius,
        ),
        (angle1 - 90) / 180 * math.pi,
        2 * math.pi,
      )
      ..lineTo(
        vertex.x,
        vertex.y,
      )
      ..lineTo(
        terminus.x,
        terminus.y,
      );

    final double circumference = 2 * math.pi * radius;
    final double checkLength =
        origin.distanceTo(vertex) + vertex.distanceTo(terminus);

    PathMetrics metrics = path.computeMetrics();

    for (PathMetric metric in metrics) {
      Path extract = metric.extractPath(
        circumference * progress,
        circumference + checkLength * progress,
      );
      canvas.drawPath(extract, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CheckMarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
