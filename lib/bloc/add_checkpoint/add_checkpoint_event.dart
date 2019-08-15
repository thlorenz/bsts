import 'package:bsts/core/shared_enums.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum AddCheckpointEventType { adding }

@immutable
class AddCheckpointEvent extends Equatable {
  AddCheckpointEvent(this.type,
      {this.checkpointLabel, this.importance = EventImportance.medium})
      : super(<dynamic>[type, checkpointLabel]);

  factory AddCheckpointEvent.adding(String checkpointLabel) {
    return AddCheckpointEvent(
      AddCheckpointEventType.adding,
      checkpointLabel: checkpointLabel,
      importance: EventImportance.medium,
    );
  }

  final AddCheckpointEventType type;
  final String checkpointLabel;
  final EventImportance importance;
}
