import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../chauffage/top_widget_chauffage.dart';

class TopWidget extends ConsumerWidget {
  const TopWidget({
    Key? key,
    required this.selectedApplication,
  }) : super(key: key);
  final String selectedApplication;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (selectedApplication.toUpperCase()) {
      case 'CHAUFFAGE':
        return const TopWidgetChauffage();
      default:
        return Container();
    }
  }
}
