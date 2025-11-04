import 'dart:async';

class Retry {
  static DateTime? _lastShownTime;
  static const Duration _cooldown = Duration(seconds: 1);
  static Timer? _retryTimer;

  /// Executes a function with cooldown and optional delay.
  /// Cancels any previous scheduled retry if not yet executed.
  static void execute(Function? callBack, {Duration? delay}) {
    final now = DateTime.now();

    // Throttle multiple rapid calls
    if (_lastShownTime != null &&
        now.difference(_lastShownTime!) < _cooldown) {
      return;
    }

    _lastShownTime = now;

    // Cancel any existing pending retry
    cancel();

    // Schedule or execute immediately
    if (delay != null) {
      _retryTimer = Timer(delay, () {
        callBack?.call();
        _retryTimer = null;
      });
    } else {
      callBack?.call();
    }
  }

  /// Cancels the currently scheduled retry (if any)
  static void cancel() {
    _retryTimer?.cancel();
    _retryTimer = null;
  }
}
