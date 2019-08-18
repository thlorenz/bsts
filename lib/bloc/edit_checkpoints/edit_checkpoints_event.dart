import 'package:bsts/core/shared_enums.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum EditCheckpointsEventType { todo }

@immutable
class EditCheckpointsEvent extends Equatable {
  EditCheckpointsEvent(this.type, {this.importance = EventImportance.medium})
      : super(<dynamic>[type]);

  final EditCheckpointsEventType type;
  final EventImportance importance;
}
