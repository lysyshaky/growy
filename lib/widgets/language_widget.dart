import 'package:flutter/material.dart';
import 'package:growy/l10n/l10n.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";

import '../services/utils.dart';

class LanguageWidget extends StatelessWidget {
  const LanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final flag = L10n.getFlag(locale.languageCode);
    final color = Utils(context).color;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Text(
            flag,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        Text(
          AppLocalizations.of(context)!.language,
          style: TextStyle(color: color, fontSize: 14),
        ),
      ],
    );
  }
}
