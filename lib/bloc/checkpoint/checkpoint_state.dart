import 'package:bsts/models/checkpoint.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:timeago/timeago.dart' as timeago;

enum CheckpointStage {
  initialized,
  changed,
  tick,
  editToggled,
}

String _lastCheck(Checkpoint checkpoint) {
  return checkpoint?.lastCheck != null
      ? timeago.format(checkpoint.lastCheck)
      : null;
}

@immutable
class CheckpointState extends Equatable {
  CheckpointState({
    @required this.stage,
    @required this.checkpoint,
    @required this.lastCheck,
    @required this.editing,
  }) : super(<dynamic>[stage, checkpoint, lastCheck, editing]);

  factory CheckpointState.initial(Checkpoint checkpoint) {
    return CheckpointState(
      stage: CheckpointStage.initialized,
      checkpoint: checkpoint,
      lastCheck: _lastCheck(checkpoint),
      editing: false,
    );
  }

  factory CheckpointState.changed(
    CheckpointState currentState,
    Checkpoint checkpoint,
  ) {
    return currentState.copyWith(
      stage: CheckpointStage.changed,
      checkpoint: checkpoint,
    );
  }

  factory CheckpointState.tick(
    CheckpointState currentState,
    Checkpoint checkpoint,
  ) {
    return currentState.copyWith(
      stage: CheckpointStage.tick,
      checkpoint: checkpoint,
    );
  }

  factory CheckpointState.editToggled(
      CheckpointState currentState, bool editing) {
    return currentState.copyWith(
      stage: CheckpointStage.editToggled,
      editing: editing,
    );
  }

  CheckpointState copyWith({
    CheckpointStage stage,
    Checkpoint checkpoint,
    bool editing,
  }) {
    return CheckpointState(
      stage: stage ?? this.stage,
      checkpoint: checkpoint ?? this.checkpoint,
      lastCheck: _lastCheck(checkpoint),
      editing: editing ?? this.editing,
    );
  }

  final CheckpointStage stage;
  final Checkpoint checkpoint;
  final String lastCheck;
  final bool editing;

  bool get checked => lastCheck != null;

  String toString() {
    return '''CheckpointState { 
      stage: $stage,
      lastCheck: $lastCheck,
      checkpoint: $checkpoint
      editing: $editing,
   }''';
  }
}
