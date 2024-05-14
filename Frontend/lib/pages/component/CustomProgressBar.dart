import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  final double totalValue;
  final double progressValue;
  final double progressBarHeight;
  final Color progressBarColor;

  CustomProgressBar({
    required this.totalValue,
    required this.progressValue,
    this.progressBarHeight = 15.0, // Set a default height or adjust as needed
    this.progressBarColor = Colors.lightBlue, // Set a default color or adjust as needed
  });

  @override
  Widget build(BuildContext context) {
    double percentage = (progressValue / totalValue).clamp(0.0, 1.0) * 100;

    return Container(
      height: progressBarHeight,
      child: Stack(
        children: [
          LinearProgressIndicator(
            value: progressValue / totalValue,
            minHeight: progressBarHeight,
            valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(color: Colors.black,fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




