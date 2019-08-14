import 'dart:async' as dart_async;

typedef OnTick = void Function(dart_async.Timer timer);

void _setTimeout(Duration duration, void onTimeout()) {
  dart_async.Timer(duration, onTimeout);
}

Future<void> _wait(Duration duration) {
  return Future.delayed(duration);
}

void _periodic(Duration duration, OnTick onTick) {
  dart_async.Timer.periodic(duration, onTick);
}

abstract class ITimer {
  void Function(Duration duration, void Function() onTimeout) get setTimeout;
  Future<void> Function(Duration duration) get wait;
  void Function(Duration duration, OnTick onTick) get periodic;
}

class Timer implements ITimer {
  void Function(Duration duration, void Function() onTimeout) get setTimeout =>
      _setTimeout;

  Future<void> Function(Duration duration) get wait => _wait;
  void Function(Duration duration, OnTick onTick) get periodic => _periodic;
}
