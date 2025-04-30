import 'package:flutter/material.dart';

class RoundedRectangle extends StatelessWidget {
  final Widget child;
  final double widthPercent;
  final double heightPercent;
  final double radius;
  final Color color;

  const RoundedRectangle({
    super.key,
    required this.child,
    required this.widthPercent,
    required this.heightPercent,
    required this.radius,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth * widthPercent;
        final height = constraints.maxHeight * heightPercent;
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: child,
        );
      },
    );
  }
}
