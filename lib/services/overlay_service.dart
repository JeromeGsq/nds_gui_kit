import 'package:signals/signals_flutter.dart';

// signals
final overlaySignal = signal(false);

// helper functions
void showOverlay() => overlaySignal.value = true;
void hideOverlay() => overlaySignal.value = false;
