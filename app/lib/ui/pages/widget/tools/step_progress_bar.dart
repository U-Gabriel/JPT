import 'package:flutter/material.dart';

class StepProgressBar extends StatelessWidget {
  final double percent;

  const StepProgressBar({Key? key, required this.percent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: percent,
          backgroundColor: Colors.grey[200],
          color: Colors.green,
          minHeight: 8,
        ),
        const SizedBox(height: 8),
        Text("${(percent * 100).toInt()}% complété",
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}