import 'package:flutter_riverpod/flutter_riverpod.dart';

// final pageReglableProvider = StateNotifierProvider<IsPageReglableNotifier, IsReglable>((ref) {
//   return IsPageReglableNotifier();
// });

// class IsPageReglableNotifier extends StateNotifier<IsReglable> {
//   IsPageReglableNotifier() : super(IsReglable(false));

//   void setReglable(IsReglable newSettable) {
//     state = newSettable;
//   }
// }

// class IsReglable {
//   IsReglable(this.reglable);
//   final bool reglable;
// }

final pageReglableProvider = StateProvider<bool>((ref) {
  return false;
});

final setupLaunchProvider = StateProvider<bool>((ref) {
  return false;
});
