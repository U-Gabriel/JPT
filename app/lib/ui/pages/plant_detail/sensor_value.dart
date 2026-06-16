import 'package:app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class SensorValue extends StatelessWidget {
  final String label;
  final dynamic value;

  const SensorValue({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$label:",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value != null ? value.toString() : AppLocalizations.of(context)!.noAvailableD,
            style: TextStyle(
              fontSize: 16,
              color: value != null ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
