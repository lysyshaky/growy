import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('uk'),
  ];
  static String getFlag(String code) {
    switch (code) {
      case 'en':
        return 'πΊπΈ';
      case 'uk':
        return 'πΊπ¦';
      default:
        return 'πΊπΈ';
    }
  }
}
