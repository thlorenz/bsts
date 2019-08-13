import 'package:bsts/models/checkpoint.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum CheckpointsStage {
  initialized,
}

@immutable
class CheckpointsState extends Equatable {
  CheckpointsState({
    @required this.stage,
    @required this.checkpoints,
  }) : super(<dynamic>[stage]);

  factory CheckpointsState.initial(List<Checkpoint> checkpoints) {
    return CheckpointsState(
      stage: CheckpointsStage.initialized,
      checkpoints: checkpoints,
    );
  }

  CheckpointsState copyWith({
    CheckpointsStage stage,
    List<Checkpoint> checkpoints,
  }) {
    return CheckpointsState(
      stage: stage ?? this.stage,
      checkpoints: checkpoints ?? this.checkpoints,
    );
  }

  final List<Checkpoint> checkpoints;
  final CheckpointsStage stage;
}
