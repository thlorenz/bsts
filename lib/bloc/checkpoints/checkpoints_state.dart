import 'package:bsts/models/checkpoint.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum CheckpointsStage {
  initialized,
  changed,
  filterChanged,
}

@immutable
class CheckpointsState extends Equatable {
  CheckpointsState({
    @required this.stage,
    @required this.checkpoints,
    @required this.filteringUnverified,
  }) : super(<dynamic>[stage, checkpoints, filteringUnverified]);

  factory CheckpointsState.initial(
      List<Checkpoint> checkpoints, bool filteringUnverified) {
    return CheckpointsState(
      stage: CheckpointsStage.initialized,
      checkpoints: checkpoints,
      filteringUnverified: filteringUnverified,
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

  CheckpointsState copyWith({
    CheckpointsStage stage,
    List<Checkpoint> checkpoints,
    bool filteringUnverified,
  }) {
    return CheckpointsState(
      stage: stage ?? this.stage,
      checkpoints: checkpoints ?? this.checkpoints,
      filteringUnverified: filteringUnverified ?? this.filteringUnverified,
    );
  }

  final List<Checkpoint> checkpoints;
  final CheckpointsStage stage;
  final bool filteringUnverified;

  String toString() {
    return '''CheckpointsState { 
      stage: $stage,
      checkpoints: $checkpoints
    }''';
  }
}
