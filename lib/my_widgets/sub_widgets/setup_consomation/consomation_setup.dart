import 'package:adomob/my_widgets/sub_widgets/setup_consomation/consomation_setup_tarifs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'consomation_setup_heures_creuses_pleines.dart';

/// ConsumerWidget for riverpod
class RootSetupWidget extends ConsumerWidget {
  const RootSetupWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Divider(
              thickness: 10,
            ),
            const SizedBox(height: 10),
            const SetupHeuresCreusesPleines(),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: const GetTarifs(),
            ),
          ],
        );
      },
      // containter frame
    );
  }
}
