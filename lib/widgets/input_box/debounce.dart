import 'dart:async';

class Debounce {
  /// Defines time delay to debounce.
  Duration delay;

  /// Defines timer to debounce after delay time.
  Timer? timer;

  Debounce(
    this.delay,
  );

  call(void Function() callback) {
    timer?.cancel();
    timer = Timer(delay, callback);
  }

  dispose() {
    timer?.cancel();
  }
}
