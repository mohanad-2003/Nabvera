import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/preferences_service.dart';

part 'locale_controller.g.dart';

const defaultLocale = Locale('ar');
const supportedLocales = [Locale('ar'), Locale('en')];

@Riverpod(keepAlive: true)
class LocaleController extends _$LocaleController {
  @override
  Locale build() {
    final stored = ref.watch(preferencesServiceProvider).locale;
    if (stored != null) {
      final match = supportedLocales.where((l) => l.languageCode == stored);
      if (match.isNotEmpty) return match.first;
    }
    return defaultLocale;
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await ref.read(preferencesServiceProvider).setLocale(locale.languageCode);
  }
}
