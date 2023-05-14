import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appBarIndexProvider = ChangeNotifierProvider<AppBarIndexChangeNotifier>((ref) => AppBarIndexChangeNotifier());

class AppBarIndexChangeNotifier extends ChangeNotifier {
  AppBarIndexChangeNotifier([
    this.appBarIndex = 0,
  ]);

  int appBarIndex;

  void setAppBarIndex(int index) {
    appBarIndex = index;
    notifyListeners();
  }
}
