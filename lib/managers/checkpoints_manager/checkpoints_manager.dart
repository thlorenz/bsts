import 'package:bsts/core/interfaces.dart';
import 'package:bsts/db/database.dart';
import 'package:bsts/models/checkpoint.dart';
import 'package:rxdart/rxdart.dart';

abstract class ICheckpointsManager implements IDisposable {
  Future<void> addCheckpoint(Checkpoint checkpoint);
  Future<void> removeCheckpoint(String id);

  Future<void> verifyCheckpoint(String id);

  Future<void> resetAll();

  Future<void> init();

  List<Checkpoint> get checkpoints;
  Observable<void> get checkpointsChanged$;
  Observable<String> get checkpointChanged$;

  Checkpoint byID(String id);
}

class CheckpointsManager implements ICheckpointsManager {
  CheckpointsManager({this.database});

  final IDatabase database;
  Map<String, Checkpoint> _checkpoints;

  final Subject<void> _checkpointsChanged$ = PublishSubject<void>();
  Observable<void> get checkpointsChanged$ => _checkpointsChanged$;

  final Subject<String> _checkpointChanged$ = PublishSubject<String>();
  Observable<String> get checkpointChanged$ => _checkpointChanged$;

  @override
  List<Checkpoint> get checkpoints =>
      _checkpoints.values.toList(); // TODO: sort by order table

  Checkpoint byID(String id) {
    assert(_checkpoints.containsKey(id));
    return _checkpoints[id];
  }

  @override
  Future<void> addCheckpoint(Checkpoint checkpoint) async {
    await database.upsertCheckpoint(checkpoint);
    _checkpoints[checkpoint.id] = checkpoint;
    _notify(checkpoint.id);
  }

  @override
  Future<void> init() async {
    _checkpoints = Map<String, Checkpoint>.fromIterable(
      await database.getCheckpoints(),
      key: (dynamic x) => (x as Checkpoint).id,
    );
  }

  @override
  Future<void> removeCheckpoint(String id) {
    // TODO: implement removeCheckpoint
    return null;
  }

  Future<void> _unverify(Checkpoint checkpoint) async {
    final cp = checkpoint.updateLastCheck(null);
    await database.upsertCheckpoint(cp);
    _checkpoints[cp.id] = cp;
    _notify(cp.id);
  }

  @override
  Future<void> verifyCheckpoint(String id) async {
    assert(_checkpoints.containsKey(id), 'checkpoint $id not found');
    final checkpoint = _checkpoints[id];
    final cp = checkpoint.updateLastCheck(DateTime.now());
    await database.upsertCheckpoint(cp);
    _checkpoints[cp.id] = cp;
    _notify(cp.id);
  }

  @override
  Future<void> resetAll() async {
    final futures = _checkpoints.values.map(_unverify);
    await Future.wait(futures);
    _notifyAll();
  }

  void _notifyAll() {
    _checkpointsChanged$.add(null);
  }

  void _notify(String id) {
    _checkpointChanged$.add(id);
  }

  @override
  void dispose() {
    _checkpointsChanged$?.close();
    _checkpointChanged$?.close();
  }
}
