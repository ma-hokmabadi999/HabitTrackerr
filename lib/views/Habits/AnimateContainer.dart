import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedContainerApp extends StatefulWidget {
  final double width;
  // final double height;
  final Color color;
  final int border;
  final bool haveAnimation;

  const AnimatedContainerApp({
    Key? key,
    required this.width,
    required this.haveAnimation,
    // required this.height,
    required this.color,
    required this.border,
    required int height,
  }) : super(key: key);

  @override
  State<AnimatedContainerApp> createState() => _AnimatedContainerAppState();
}

class _AnimatedContainerAppState extends State<AnimatedContainerApp> {
  // Define the various properties with default values. Update these properties
  // when the user taps a FloatingActionButton.
  // double _width = wi;
  // double _height = 50;
  // Color _color = Colors.green;
  // BorderRadiusGeometry _borderRadius = BorderRadius.circular();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      // Use the properties stored in the State class.
      width: widget.width,
      // height: widget.height,
      decoration: BoxDecoration(
        color: widget.color,
        // borderRadius: BorderRadius.circular(widget.border.toDouble()),
      ),
      // Define how long the animation should take.
      duration: Duration(
          milliseconds: (widget.haveAnimation
              ? 550
              : widget.width.toInt() == 0
                  ? 550
                  : 30)),
      // Provide an optional curve to make the animation feel smoother.
      curve: Curves.fastOutSlowIn,
    );
  }
}
