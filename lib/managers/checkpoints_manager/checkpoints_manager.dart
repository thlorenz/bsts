import 'package:bsts/core/interfaces.dart';
import 'package:bsts/db/database.dart';
import 'package:bsts/models/checkpoint.dart';
import 'package:rxdart/rxdart.dart';

enum ReorderDirection { backward, forward }

abstract class ICheckpointsManager implements IDisposable {
  Future<void> addCheckpoint(Checkpoint checkpoint);
  Future<void> removeCheckpoint(String id);

  Future<void> verifyCheckpoint(String id);

  Future<void> resetAll();
  Future<void> reorder(int oldIdx, int newIdx);

  Future<void> init();

  List<Checkpoint> get checkpoints;
  Observable<void> get checkpointsChanged$;
  Observable<String> get checkpointChanged$;

  Checkpoint byID(String id);
  bool hasID(String id);
}

class CheckpointsManager implements ICheckpointsManager {
  CheckpointsManager({this.database});

  final IDatabase database;
  Map<String, Checkpoint> _checkpoints;

  final Subject<void> _checkpointsChanged$ = PublishSubject<void>();
  Observable<void> get checkpointsChanged$ => _checkpointsChanged$;

  final Subject<String> _checkpointChanged$ = PublishSubject<String>();
  Observable<String> get checkpointChanged$ => _checkpointChanged$;

  List<String> _orderedIDs;

  @override
  List<Checkpoint> get checkpoints => _checkpoints.values.toList()
    ..sort((a, b) =>
        _orderedIDs.indexOf(a.id).compareTo(_orderedIDs.indexOf(b.id)));

  Checkpoint byID(String id) {
    assert(_checkpoints.containsKey(id));
    return _checkpoints[id];
  }

  bool hasID(String id) {
    return _checkpoints.containsKey(id);
  }

  @override
  Future<void> addCheckpoint(Checkpoint checkpoint) async {
    _checkpoints[checkpoint.id] = checkpoint;
    _orderedIDs.add(checkpoint.id);
    await database.upsertCheckpoint(checkpoint);
    await database.upsertOrderedCheckpointIDs(_orderedIDs);
    _notify(checkpoint.id);
    _notifyAll();
  }

  @override
  Future<void> init() async {
    _checkpoints = Map<String, Checkpoint>.fromIterable(
      await database.getCheckpoints(),
      key: (dynamic x) => (x as Checkpoint).id,
    );
    _orderedIDs = await database.getOrderedCheckpointIDs();
    if (_syncOrderedIDs()) {
      await database.upsertOrderedCheckpointIDs(_orderedIDs);
    }
  }

  bool _syncOrderedIDs() {
    // Remove ids that no longer have a checkpoint
    _orderedIDs =
        _orderedIDs.where((id) => _checkpoints.containsKey(id)).toList();
    if (_orderedIDs.length == _checkpoints.length) return false;

    // Add checkpoint ids not yet inside ordered list
    for (final id in _checkpoints.keys) {
      if (_orderedIDs.contains(id)) continue;
      _orderedIDs.add(id);
    }
    return true;
  }

  Future<void> reorder(int oldIdx, int newIdx) async {
    final int tgtIdx = newIdx > oldIdx ? newIdx - 1 : newIdx;
    final id = _orderedIDs.removeAt(oldIdx);
    _orderedIDs.insert(tgtIdx, id);
    _notifyAll();
    await database.upsertOrderedCheckpointIDs(_orderedIDs);
  }

  @override
  Future<void> removeCheckpoint(String id) async {
    assert(
      _checkpoints.containsKey(id),
      'cannot remove non-existing checkpoint',
    );
    _checkpoints.remove(id);
    _orderedIDs.remove(id);

    _notifyAll();
    await database.deleteCheckpoint(id);
    await database.upsertOrderedCheckpointIDs(_orderedIDs);
  }

  Future<void> _unverify(Checkpoint checkpoint) async {
    final cp = checkpoint.updateLastCheck(null);
    _checkpoints[cp.id] = cp;
    _notify(cp.id);
    await database.upsertCheckpoint(cp);
  }

  @override
  Future<void> verifyCheckpoint(String id) async {
    assert(_checkpoints.containsKey(id), 'checkpoint $id not found');
    final checkpoint = _checkpoints[id];
    final cp = checkpoint.updateLastCheck(DateTime.now());
    _checkpoints[cp.id] = cp;
    _notify(cp.id);
    await database.upsertCheckpoint(cp);
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
