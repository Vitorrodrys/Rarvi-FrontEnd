import 'package:flutter/material.dart';


class CardInfo extends StatelessWidget {

  final Color color;
  final int countInfo;
  final String message;

  CardInfo({required this.color, required this.countInfo, required this.message});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
           Text(
            countInfo.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          )
        ],
      )
    );
  }
}
