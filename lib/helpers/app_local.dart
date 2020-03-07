import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///本地化配置
class AppL {
  final Locale locale;

  AppL(this.locale);

  static AppL of(BuildContext context) {
    return Localizations.of<AppL>(context, AppL);
  }

  static LocalizationsDelegate<AppL> delegate = _ApplocalizationsDelegate();

  Map<String, String> _localizedStrings;

  Future<bool> load() async {
    String jsonString =
        await rootBundle.loadString('lang/${locale.languageCode}.json');

    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key];
  }
}

class _ApplocalizationsDelegate extends LocalizationsDelegate<AppL> {
  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppL> load(Locale locale) async {
    AppL localizations = AppL(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppL> old) => false;
}
