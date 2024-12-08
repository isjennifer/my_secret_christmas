import 'dart:math';
import 'package:flutter/material.dart';

class SnowTheme extends InheritedWidget {
  final bool showSnow;

  const SnowTheme({
    super.key,
    required this.showSnow,
    required super.child,
  });

  static SnowTheme of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SnowTheme>()!;
  }

  @override
  bool updateShouldNotify(SnowTheme oldWidget) {
    return showSnow != oldWidget.showSnow;
  }
}
