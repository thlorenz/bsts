import 'package:bsts/models/checkpoint.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum CheckpointsStage {
  initialized,
  changed,
  filterChanged,
  editToggled,
}

@immutable
class CheckpointsState extends Equatable {
  CheckpointsState({
    @required this.stage,
    @required this.checkpoints,
    @required this.filteringUnverified,
    @required this.editing,
  }) : super(<dynamic>[stage, checkpoints, filteringUnverified, editing]);

  factory CheckpointsState.initial(
      List<Checkpoint> checkpoints, bool filteringUnverified) {
    return CheckpointsState(
      stage: CheckpointsStage.initialized,
      checkpoints: checkpoints,
      filteringUnverified: filteringUnverified,
      editing: false,
    );
  }

  factory CheckpointsState.changed(
    CheckpointsState current,
    List<Checkpoint> checkpoints,
  ) {
    return current.copyWith(
      stage: CheckpointsStage.changed,
      checkpoints: checkpoints,
    );
  }

  factory CheckpointsState.filterChanged(
    CheckpointsState current,
    List<Checkpoint> checkpoints,
    bool filteringUnverified,
  ) {
    return current.copyWith(
      stage: CheckpointsStage.filterChanged,
      checkpoints: checkpoints,
      filteringUnverified: filteringUnverified,
    );
  }

  factory CheckpointsState.editToggled(
      CheckpointsState currentState, bool editing) {
    return currentState.copyWith(
      stage: CheckpointsStage.editToggled,
      editing: editing,
    );
  }
  CheckpointsState copyWith({
    CheckpointsStage stage,
    List<Checkpoint> checkpoints,
    bool filteringUnverified,
    bool editing,
  }) {
    return CheckpointsState(
      stage: stage ?? this.stage,
      checkpoints: checkpoints ?? this.checkpoints,
      filteringUnverified: filteringUnverified ?? this.filteringUnverified,
      editing: editing ?? this.editing,
    );
  }

  final List<Checkpoint> checkpoints;
  final CheckpointsStage stage;
  final bool filteringUnverified;
  final bool editing;

  String toString() {
    return '''CheckpointsState { 
      stage: $stage,
      checkpoints: $checkpoints
      filteringUnverified: $filteringUnverified
      editing: $editing,
    }''';
  }
}
