import 'package:bsts/models/checkpoint.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:timeago/timeago.dart' as timeago;

enum CheckpointStage {
  initialized,
  changed,
  tick,
}

String _lastCheck(Checkpoint checkpoint) {
  return checkpoint.lastCheck != null
      ? timeago.format(checkpoint.lastCheck)
      : null;
}

@immutable
class CheckpointState extends Equatable {
  CheckpointState({
    @required this.stage,
    @required this.checkpoint,
    @required this.lastCheck,
  }) : super(<dynamic>[stage, checkpoint, lastCheck]);

  factory CheckpointState.initial(Checkpoint checkpoint) {
    return CheckpointState(
      stage: CheckpointStage.initialized,
      checkpoint: checkpoint,
      lastCheck: _lastCheck(checkpoint),
    );
  }

  factory CheckpointState.changed(
    CheckpointState current,
    Checkpoint checkpoint,
  ) {
    return current.copyWith(
      stage: CheckpointStage.changed,
      checkpoint: checkpoint,
    );
  }

  factory CheckpointState.tick(
    CheckpointState current,
    Checkpoint checkpoint,
  ) {
    return current.copyWith(
      stage: CheckpointStage.tick,
      checkpoint: checkpoint,
    );
  }

  CheckpointState copyWith({
    CheckpointStage stage,
    Checkpoint checkpoint,
  }) {
    return CheckpointState(
      stage: stage ?? this.stage,
      checkpoint: checkpoint ?? this.checkpoint,
      lastCheck: _lastCheck(checkpoint),
    );
  }

  final CheckpointStage stage;
  final Checkpoint checkpoint;
  final String lastCheck;

  bool get checked => lastCheck != null;

  String toString() {
    return '''CheckpointState { 
      stage: $stage,
      lastCheck: $lastCheck,
      checkpoint: $checkpoint
   }''';
  }
}
