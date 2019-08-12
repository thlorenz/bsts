import 'dart:async' as dart_async;

void _setTimeout(Duration duration, void onTimeout()) {
  dart_async.Timer(duration, onTimeout);
}

Future<void> _wait(Duration duration) {
  return Future.delayed(duration);
}

abstract class ITimer {
  void Function(Duration duration, void Function() onTimeout) get setTimeout;
  Future<void> Function(Duration duration) get wait;
}

class Timer implements ITimer {
  void Function(Duration duration, void Function() onTimeout) get setTimeout =>
      _setTimeout;

  Future<void> Function(Duration duration) get wait => _wait;
}
