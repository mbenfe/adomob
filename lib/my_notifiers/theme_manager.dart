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

class ThemeModeNotifier extends StateNotifier<bool> {
  ThemeModeNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, bool>(
  (ref) => ThemeModeNotifier(),
);
