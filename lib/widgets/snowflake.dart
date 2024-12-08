import 'dart:math';
import 'package:flutter/material.dart';

// 눈송이를 표현하는 클래스
class SnowFlake {
  double x;
  double y;
  double speed;
  double radius;
  double wind;

  SnowFlake({
    required this.x,
    required this.y,
    required this.speed,
    required this.radius,
    required this.wind,
  });

  void fall(Size size, double delta) {
    y += speed * delta;
    x += wind * delta;

    if (y > size.height) {
      y = 0;
      x = Random().nextDouble() * size.width;
    }

    if (x > size.width) {
      x = 0;
    } else if (x < 0) {
      x = size.width;
    }
  }
}

// 눈 내리는 효과를 그리는 CustomPainter
class SnowPainter extends CustomPainter {
  final List<SnowFlake> snowflakes;

  SnowPainter(this.snowflakes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    for (var snowflake in snowflakes) {
      canvas.drawCircle(
        Offset(snowflake.x, snowflake.y),
        snowflake.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// 눈 내리는 효과를 포함하는 위젯
class SnowfallWidget extends StatefulWidget {
  final int numberOfSnowflakes;
  final Color snowColor;

  const SnowfallWidget({
    Key? key,
    this.numberOfSnowflakes = 100,
    this.snowColor = Colors.white,
  }) : super(key: key);

  @override
  _SnowfallWidgetState createState() => _SnowfallWidgetState();
}

class _SnowfallWidgetState extends State<SnowfallWidget>
    with SingleTickerProviderStateMixin {
  late List<SnowFlake> snowflakes;
  late AnimationController _controller;
  late DateTime _lastTime;

  @override
  void initState() {
    super.initState();
    _initializeSnowflakes();
    _setupAnimation();
  }

  void _initializeSnowflakes() {
    final random = Random();
    snowflakes = List.generate(
      widget.numberOfSnowflakes,
      (index) => SnowFlake(
        x: random.nextDouble() * 400,
        y: random.nextDouble() * 800,
        speed: 50 + random.nextDouble() * 100,
        radius: 1 + random.nextDouble() * 2,
        wind: (random.nextDouble() - 0.5) * 20,
      ),
    );
    _lastTime = DateTime.now();
  }

  void _setupAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _controller.addListener(_updateSnowflakes);
  }

  void _updateSnowflakes() {
    final now = DateTime.now();
    final delta = now.difference(_lastTime).inMilliseconds / 1000;
    _lastTime = now;

    for (var snowflake in snowflakes) {
      snowflake.fall(MediaQuery.of(context).size, delta);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SnowPainter(snowflakes),
      child: const SizedBox.expand(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
