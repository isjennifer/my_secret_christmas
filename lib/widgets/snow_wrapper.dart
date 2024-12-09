import 'dart:math';
import 'package:flutter/material.dart';
import 'snowflake.dart';
import 'snow_theme.dart';

class SnowWrapper extends StatelessWidget {
  final Widget child;

  const SnowWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (SnowTheme.of(context).showSnow)
          IgnorePointer(
            child: RepaintBoundary(
              child: SnowfallWidget(
                numberOfSnowflakes: 50,
                snowColor: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
