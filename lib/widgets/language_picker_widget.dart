import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import 'package:provider/provider.dart';
import '../l10n/l10n.dart';
import '../providers/locale_provider.dart';
import '../services/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguagePickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LocaleProvider>(context);
    final locale = languageProvider.locale;
    final color = Utils(context).color;
    final iconColor = Utils(context).iconColor;
    final dropDownColor = Utils(context).appBarcolor;
    return Row(
      children: [
        const SizedBox(
          width: 16,
        ),
        Icon(
          Icons.language,
          color: iconColor,
          size: 24,
        ),
        const SizedBox(
          width: 30,
        ),
        DropdownButtonHideUnderline(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: DropdownButton(
              hint: Text(
                AppLocalizations.of(context)!.lang,
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: Icon(
                Icons.arrow_drop_down,
                color: color,
                size: 24.0,
              ),
              dropdownColor: dropDownColor,
              items: L10n.all.map((locale) {
                final flag = L10n.getFlag(locale.languageCode);
                return DropdownMenuItem(
                  value: locale,
                  onTap: () {
                    final languageProvider =
                        Provider.of<LocaleProvider>(context, listen: false);
                    languageProvider.setLocale(locale);
                  },
                  child: Row(
                    children: [
                      Text(flag, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 8),
                      Text(locale.languageCode == "en"
                          ? "English"
                          : "Українська"),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (_) {},
            ),
          ),
        ),
      ],
    );
  }
}
