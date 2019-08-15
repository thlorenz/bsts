import 'package:bsts/models/checkpoint.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum AddCheckpointStage {
  initialized,
}

@immutable
class AddCheckpointState extends Equatable {
  AddCheckpointState({
    @required this.stage,
    @required this.checkpoints,
  }) : super(<dynamic>[stage, checkpoints]);

  factory AddCheckpointState.initial(List<Checkpoint> checkpoints) {
    return AddCheckpointState(
      stage: AddCheckpointStage.initialized,
      checkpoints: checkpoints,
    );
  }

  AddCheckpointState copyWith({
    AddCheckpointStage stage,
    List<Checkpoint> checkpoints,
  }) {
    return AddCheckpointState(
      stage: stage ?? this.stage,
      checkpoints: checkpoints ?? this.checkpoints,
    );
  }

  final AddCheckpointStage stage;
  final List<Checkpoint> checkpoints;
}
