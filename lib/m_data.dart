import 'package:flutter/foundation.dart';

import 'my_widgets/chauffage/chauffage_data.dart';

void initialiseDefaultData(String nomApplication) {
  if (kDebugMode) {
    print('Nom application:$nomApplication');
  }
  switch (nomApplication.toUpperCase()) {
    case 'CHAUFFAGE':
      buildChauffagesConfigurations();
      break;
    default:
  }
}
