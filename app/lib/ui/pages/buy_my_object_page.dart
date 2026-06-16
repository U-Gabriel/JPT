import 'package:app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class BuyMyObjectPage extends StatelessWidget {
  const BuyMyObjectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.gdomeStoreD)),
      body: Center(
        child: Text(
          AppLocalizations.of(context)!.welcomeStoreD,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}