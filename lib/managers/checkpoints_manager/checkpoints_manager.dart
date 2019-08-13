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

  Future<void> init();

  List<Checkpoint> get checkpoints;
  Observable<void> get checkpointsChanged$;
}

class CheckpointsManager implements ICheckpointsManager {
  CheckpointsManager({this.database});

  final IDatabase database;
  List<Checkpoint> _checkpoints;

  final Subject<void> _checkpointsChanged$ = PublishSubject<void>();
  Observable<void> get checkpointsChanged$ => _checkpointsChanged$;

  @override
  List<Checkpoint> get checkpoints => _checkpoints; // TODO: sort by order table

  @override
  Future<void> addCheckpoint(Checkpoint checkpoint) {
    // TODO: implement addCheckpoint
    return null;
  }

  @override
  Future<void> init() async {
    // _checkpoints = await database.getAll();
    _checkpoints = CheckpointMocks.allCheckpoints;
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

  @override
  Future<void> verifyCheckpoint(String id) {
    // TODO: implement verifyCheckpoint
    return null;
  }

  @override
  void dispose() {
    _checkpointsChanged$?.close();
  }
}
