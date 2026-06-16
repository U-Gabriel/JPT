import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';

class StepProgressBar extends StatelessWidget {
  final double percent;

  const StepProgressBar({Key? key, required this.percent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int percentValue = (percent * 100).toInt();
    return Column(
      children: [
        LinearProgressIndicator(
          value: percent,
          backgroundColor: Colors.grey[200],
          color: Colors.green,
          minHeight: 8,
        ),
        const SizedBox(height: 8),
        Text(AppLocalizations.of(context)!.progressBarCompleted(percentValue.toString()),
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}