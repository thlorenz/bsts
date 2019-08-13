import 'package:bsts/core/shared_enums.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum CheckpointsEventType { todo }

@immutable
class CheckpointsEvent extends Equatable {
  CheckpointsEvent(this.type, {this.importance = EventImportance.medium})
      : super(<dynamic>[type]);

  final CheckpointsEventType type;
  final EventImportance importance;
}
