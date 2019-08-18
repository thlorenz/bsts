import 'package:bsts/models/checkpoint.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum CheckpointsTrigger {
  initialized,
  changed,
  filterChanged,
}

@immutable
class CheckpointsState extends Equatable {
  CheckpointsState({
    @required this.trigger,
    @required this.checkpoints,
    @required this.filteringUnverified,
  }) : super(<dynamic>[trigger, checkpoints, filteringUnverified]);

  factory CheckpointsState.initial(
      List<Checkpoint> checkpoints, bool filteringUnverified) {
    return CheckpointsState(
      trigger: CheckpointsTrigger.initialized,
      checkpoints: checkpoints,
      filteringUnverified: filteringUnverified,
    );
  }

  factory CheckpointsState.changed(
    CheckpointsState current,
    List<Checkpoint> checkpoints,
  ) {
    return current.copyWith(
      trigger: CheckpointsTrigger.changed,
      checkpoints: checkpoints,
    );
  }

  factory CheckpointsState.filterChanged(
    CheckpointsState current,
    List<Checkpoint> checkpoints,
    bool filteringUnverified,
  ) {
    return current.copyWith(
      trigger: CheckpointsTrigger.filterChanged,
      checkpoints: checkpoints,
      filteringUnverified: filteringUnverified,
    );
  }

  CheckpointsState copyWith({
    CheckpointsTrigger trigger,
    List<Checkpoint> checkpoints,
    bool filteringUnverified,
  }) {
    return CheckpointsState(
      trigger: trigger ?? this.trigger,
      checkpoints: checkpoints ?? this.checkpoints,
      filteringUnverified: filteringUnverified ?? this.filteringUnverified,
    );
  }

  final List<Checkpoint> checkpoints;
  final CheckpointsTrigger trigger;
  final bool filteringUnverified;

  String toString() {
    return '''CheckpointsState { 
      trigger: $trigger,
      checkpoints: $checkpoints
      filteringUnverified: $filteringUnverified
    }''';
  }
}
