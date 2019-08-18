import 'package:bsts/models/checkpoint.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum EditCheckpointsTrigger {
  initialized,
  changed,
}

@immutable
class EditCheckpointsState extends Equatable {
  EditCheckpointsState({
    @required this.trigger,
    @required this.checkpoints,
  }) : super(<dynamic>[trigger, checkpoints]);

  factory EditCheckpointsState.initial(List<Checkpoint> checkpoints) {
    return EditCheckpointsState(
      trigger: EditCheckpointsTrigger.initialized,
      checkpoints: checkpoints,
    );
  }

  factory EditCheckpointsState.changed(
    EditCheckpointsState currentState,
    List<Checkpoint> checkpoints,
  ) {
    return currentState.copyWith(
      trigger: EditCheckpointsTrigger.changed,
      checkpoints: checkpoints,
    );
  }

  EditCheckpointsState copyWith({
    EditCheckpointsTrigger trigger,
    List<Checkpoint> checkpoints,
  }) {
    return EditCheckpointsState(
      trigger: trigger ?? this.trigger,
      checkpoints: checkpoints ?? this.checkpoints,
    );
  }

  final List<Checkpoint> checkpoints;
  final EditCheckpointsTrigger trigger;

  String toString() {
    return '''CheckpointsState { 
      trigger: $trigger,
      checkpoints: $checkpoints
    }''';
  }
}
