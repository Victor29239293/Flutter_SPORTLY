

import 'package:flutter_app_sportly/presentation/screens/providers/torneo_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Proveedor de tipo ChangeNotifier
final providerTorneo = ChangeNotifierProvider<TorneoProvider>((ref) {
  return TorneoProvider();
});

