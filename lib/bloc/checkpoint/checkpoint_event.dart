import 'package:bsts/core/shared_enums.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum CheckpointEventType { todo }

@immutable
class CheckpointEvent extends Equatable {
  CheckpointEvent(this.type, {this.importance = EventImportance.medium})
      : super(<dynamic>[type]);

  final CheckpointEventType type;
  final EventImportance importance;
}
