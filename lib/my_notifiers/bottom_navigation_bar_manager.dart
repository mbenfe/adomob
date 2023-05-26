import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomNavigationBarIndexProvider =
    ChangeNotifierProvider<BottomNavigationBarIndexChangeNotifier>((ref) => BottomNavigationBarIndexChangeNotifier());

class BottomNavigationBarIndexChangeNotifier extends ChangeNotifier {
  BottomNavigationBarIndexChangeNotifier([
    this.bottomNavigationBarIndex = 0,
  ]);

  int bottomNavigationBarIndex;

  void setBottomNavigationBarIndex(int index) {
    bottomNavigationBarIndex = index;
    notifyListeners();
  }
}
