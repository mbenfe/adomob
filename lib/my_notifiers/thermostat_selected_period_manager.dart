import 'package:flutter_riverpod/flutter_riverpod.dart';

// class SelectedPeriodNotifier extends StateProvider<String> {
//   SelectedPeriodNotifier() : super('SEMAINE');

//   void toggle(String newPeriod) {
//     state = newPeriod;
//   }
// }

// class Periode {
//   Periode(this.periode);
//   final String periode;
// }

// final selectedPeriodProvider = StateNotifierProvider<SelectedPeriodNotifier, String>((ref) => SelectedPeriodNotifier());

String selectedPeriode = 'SEMAINE';

final selectedPeriodProvider = StateProvider<String>((ref) => selectedPeriode);
