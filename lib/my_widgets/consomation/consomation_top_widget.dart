import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../sub_widgets/setup_consomation/consomation_setup.dart';
import 'consomation_notifiers.dart';

List<String> labels = ['MANUEL', 'AUTO', 'ABSENCE'];

class TopWidgetConsomation extends ConsumerStatefulWidget {
  const TopWidgetConsomation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TopWidgetConsomationState();
}

class _TopWidgetConsomationState extends ConsumerState<TopWidgetConsomation> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            setState(
              () {
                ref.read(consomationsetupLaunchProvider.notifier).state = true;
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return const RootSetupWidget();
                  },
                );
              },
            );
          },
          icon: const Icon(Icons.settings),
        ),
      ],
    ));
  }
}

String formatLabels(dynamic value, String formatted) {
  switch (value) {
    case 0:
      return 'MANUEL';
    case 1:
      return 'AUTO';
    case 2:
      return 'ABSENCE';
  }
  return value.toString();
}

class LaunchSetup extends ConsumerStatefulWidget {
  const LaunchSetup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LaunchSetupState();
}

class _LaunchSetupState extends ConsumerState<LaunchSetup> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
