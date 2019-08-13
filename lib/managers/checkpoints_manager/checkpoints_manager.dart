import 'package:bsts/core/interfaces.dart';
import 'package:bsts/db/database.dart';
import 'package:bsts/managers/checkpoints_manager/checkpoint_mocks.dart';
import 'package:bsts/models/checkpoint.dart';
import 'package:rxdart/rxdart.dart';

abstract class ICheckpointsManager implements IDisposable {
  Future<void> addCheckpoint(Checkpoint checkpoint);
  Future<void> removeCheckpoint(String id);
  Future<void> resetCheckpoints();

  Future<void> verifyCheckpoint(String id);
  Future<void> unverifyCheckpoint(String id);

  Future<void> resetAll();

  Future<void> init();

  List<Checkpoint> get checkpoints;
  Observable<void> get checkpointsChanged$;
}

class CheckpointsManager implements ICheckpointsManager {
  CheckpointsManager({this.database});

  final IDatabase database;
  Map<String, Checkpoint> _checkpoints;

  final Subject<void> _checkpointsChanged$ = PublishSubject<void>();
  Observable<void> get checkpointsChanged$ => _checkpointsChanged$;

  @override
  List<Checkpoint> get checkpoints =>
      _checkpoints.values.toList(); // TODO: sort by order table

  @override
  Future<void> addCheckpoint(Checkpoint checkpoint) {
    // TODO: implement addCheckpoint
    return null;
  }

  @override
  Future<void> init() async {
    // _checkpoints = await database.getAll();
    _checkpoints = Map<String, Checkpoint>.fromIterable(
      CheckpointMocks.allCheckpoints,
      key: (dynamic x) => (x as Checkpoint).id,
    );
  }

  @override
  Future<void> removeCheckpoint(String id) {
    // TODO: implement removeCheckpoint
    return null;
  }

  @override
  Future<void> resetCheckpoints() {
    // TODO: implement resetCheckpoints
    return null;
  }

  @override
  Future<void> unverifyCheckpoint(String id) {
    // TODO: implement unverifyCheckpoint
    return null;
  }

  Future<void> _unverify(Checkpoint checkpoint) async {
    final cp = checkpoint.updateLastCheck(null);
    await database.upsertCheckpoint(checkpoint);
    _checkpoints[cp.id] = cp;
  }

  @override
  Future<void> verifyCheckpoint(String id) {
    // TODO: implement verifyCheckpoint
    return null;
  }

  @override
  Future<void> resetAll() async {
    final futures = _checkpoints.values.map(_unverify);
    await Future.wait(futures);
    _checkpointsChanged$.add(null);
  }

  @override
  void dispose() {
    _checkpointsChanged$?.close();
  }
}
