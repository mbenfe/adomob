// ThemeManager themeManager = ThemeManager();

// class ThemeManager with ChangeNotifier {
//   ThemeMode _themeMode = ThemeMode.light;

//   get themeMode => _themeMode;

//   toggleTheme(bool isDark) {
//     _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
//     notifyListeners();
//   }
// }

import 'package:flutter_riverpod/flutter_riverpod.dart';

class DarkModeNotifier extends StateNotifier<bool> {
  DarkModeNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}

final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>(
  (ref) => DarkModeNotifier(),
);
