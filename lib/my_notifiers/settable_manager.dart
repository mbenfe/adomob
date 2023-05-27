import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageReglableProvider = StateNotifierProvider<IsPageReglableNotifier, IsReglable>((ref) {
  return IsPageReglableNotifier();
});

class IsPageReglableNotifier extends StateNotifier<IsReglable> {
  IsPageReglableNotifier() : super(IsReglable(false));

  void setReglable(IsReglable newSettable) {
    state = newSettable;
  }
}

class IsReglable {
  IsReglable(this.reglable);
  final bool reglable;
}
