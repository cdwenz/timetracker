// lib/widgets/language_picker.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../localization/language_controller.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageController>();
    final items = const [
      Locale('es'), Locale('en'), Locale('pt'), Locale('fr'), Locale('ru'),
    ];

    return DropdownButton<Locale>(
      value: lang.locale ?? const Locale('es'),
      underline: const SizedBox.shrink(),
      items: items.map((l) {
        final label = switch (l.languageCode) {
          'es' => 'Español',
          'en' => 'English',
          'pt' => 'Português',
          'fr' => 'Français',
          'ru' => 'Русский',
          _ => l.languageCode,
        };
        return DropdownMenuItem(value: l, child: Text(label));
      }).toList(),
      onChanged: (value) {
        if (value != null) lang.setLocale(value);
      },
    );
  }
}
