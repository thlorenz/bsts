import 'package:bsts/bloc/add_checkpoint/add_checkpoint_event.dart';
import 'package:bsts/bloc/add_checkpoint/add_checkpoint_state.dart';
import 'package:bsts/core/log.dart';
import 'package:bsts/managers/checkpoints_manager/checkpoints_manager.dart';
import 'package:bsts/models/checkpoint.dart';
import 'package:bsts/packages/se_bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

export 'package:bsts/bloc/add_checkpoint/add_checkpoint_bloc.ui.dart';
export 'package:bsts/bloc/add_checkpoint/add_checkpoint_event.dart';
export 'package:bsts/bloc/add_checkpoint/add_checkpoint_state.dart';

final _log = Log<AddCheckpointBloc>();
final _uuid = Uuid();

class AddCheckpointBloc
    extends BlocBase<AddCheckpointState, AddCheckpointEvent> {
  AddCheckpointBloc({
    @required this.checkpointsManager,
    @required this.category,
    @required List<Checkpoint> checkpoints,
    InspectItem<AddCheckpointState> inspectState,
    InspectItem<AddCheckpointEvent> inspectEvent,
  }) : super(
          initialState: AddCheckpointState.initial(checkpoints),
          inspectState: inspectState,
          inspectEvent: inspectEvent,
        ) {
    _log.finest(() => 'creating');
  }

  final String category;
  final ICheckpointsManager checkpointsManager;

  void addCheckpoint(Checkpoint checkpoint) {
    _log.fine(() => 'Adding checkpoint ${checkpoint.id}');
    checkpointsManager.addCheckpoint(checkpoint.copyWith(id: _uuid.v4()));
    event(AddCheckpointEvent.adding(checkpoint.label));
  }

  @override
  void dispose() {
    _log.finest(() => 'disposing');
    super.dispose();
  }
}
