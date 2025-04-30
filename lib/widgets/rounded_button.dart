import 'package:flutter/material.dart';


class RoundedButton extends StatelessWidget {

  final String text;
  final Color color;
  final Color textColor;
  final double radius;
  final VoidCallback onPressed;

  const RoundedButton({
    super.key,
    required this.text,
    required this.color,
    required this.textColor,
    required this.radius,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        minimumSize: Size.fromHeight(50),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}