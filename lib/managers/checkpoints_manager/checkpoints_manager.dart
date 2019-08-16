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
  Future<void> reorder(String id, ReorderDirection direction, {int step});
  bool canReorder(String id, ReorderDirection direction, {int step});

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

  List<String> _orderedIDs;

  @override
  List<Checkpoint> get checkpoints => _checkpoints.values.toList()
    ..sort((a, b) =>
        _orderedIDs.indexOf(a.id).compareTo(_orderedIDs.indexOf(b.id)));

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

  bool canReorder(String id, ReorderDirection direction, {int step = 1}) {
    final idx = _orderedIDs.indexOf(id);
    switch (direction) {
      case ReorderDirection.backward:
        return idx > step;
      case ReorderDirection.forward:
        return idx + step < _orderedIDs.length;
      default:
        throw ArgumentError('Invalid direction: $direction');
    }
  }

  Future<void> reorder(String id, ReorderDirection direction,
      {int step = 1}) async {
    final idx = _orderedIDs.indexOf(id);
    assert(idx >= 0, '$id not in $_orderedIDs');

    switch (direction) {
      case ReorderDirection.backward:
        _reorderBackward(id, idx);
        break;
      case ReorderDirection.forward:
        _reorderForward(id, idx);
        break;
    }

    await database.upsertOrderedCheckpointIDs(_orderedIDs);
    _notifyAll();
  }

  void _reorderBackward(String id, int idx) {
    assert(idx > 0, 'cannot move first item back');
    final idBefore = _orderedIDs[idx - 1];
    _orderedIDs[idx] = idBefore;
    _orderedIDs[idx - 1] = id;
  }

  void _reorderForward(String id, int idx) {
    assert(idx < _orderedIDs.length, 'cannot move last item forward');
    final idAfter = _orderedIDs[idx + 1];
    _orderedIDs[idx] = idAfter;
    _orderedIDs[idx + 1] = id;
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
