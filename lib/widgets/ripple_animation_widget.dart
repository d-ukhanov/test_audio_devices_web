import 'dart:math' as math show sin, pi, sqrt;

import 'package:flutter/material.dart';

class RippleAnimationWidget extends StatefulWidget {
  final bool display;
  final double size;
  final Color color;

  const RippleAnimationWidget({
    super.key,
    this.display = true,
    this.size = 100.0,
    this.color = Colors.red,
  });

  @override
  _RippleAnimationWidgetState createState() => _RippleAnimationWidgetState();
}

class _RippleAnimationWidgetState extends State<RippleAnimationWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.display
        ? CustomPaint(
            painter: CirclePainter(
              _controller,
              color: widget.color,
            ),
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: _buildAnimatedCircle(),
            ),
          )
        : const SizedBox();
  }

  Widget _buildAnimatedCircle() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.size),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                widget.color,
                Color.lerp(widget.color, Colors.black, .05) ?? widget.color,
              ],
            ),
          ),
          child: ScaleTransition(
            scale: Tween(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(
                parent: _controller,
                curve: const PulsateCurve(),
              ),
            ),
            child: const SizedBox(),
          ),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  CirclePainter(
    this.animation, {
    required this.color,
  }) : super(repaint: animation);

  void drawCircle(Canvas canvas, Rect rect, double value) {
    final double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    final double size = rect.width / 2;
    final double area = size * size;
    final double radius = math.sqrt(area * value / 4);

    final Paint paint = Paint()..color = color.withOpacity(opacity);
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    for (int wave = 3; wave >= 0; wave--) {
      drawCircle(canvas, rect, wave + animation.value);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}

class PulsateCurve extends Curve {
  const PulsateCurve();

  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return 0.01;
    }
    return math.sin(t * math.pi);
  }
}
