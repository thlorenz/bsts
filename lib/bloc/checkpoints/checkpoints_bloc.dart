import 'package:bsts/bloc/checkpoints/checkpoints_event.dart';
import 'package:bsts/bloc/checkpoints/checkpoints_state.dart';
import 'package:bsts/core/log.dart';
import 'package:bsts/managers/checkpoints_manager/checkpoints_manager.dart';
import 'package:bsts/packages/se_bloc/bloc.dart';
import 'package:meta/meta.dart';

export 'package:bsts/bloc/checkpoints/checkpoints_bloc.ui.dart';
export 'package:bsts/bloc/checkpoints/checkpoints_event.dart';
export 'package:bsts/bloc/checkpoints/checkpoints_state.dart';

final _log = Log<CheckpointsBloc>();

class CheckpointsBloc extends BlocBase<CheckpointsState, CheckpointsEvent> {
  CheckpointsBloc({
    @required this.checkpointsManager,
    InspectItem<CheckpointsState> inspectState,
    InspectItem<CheckpointsEvent> inspectEvent,
  }) : super(
          initialState: CheckpointsState.initial(
            checkpointsManager.checkpoints,
          ),
          inspectState: inspectState,
          inspectEvent: inspectEvent,
        ) {
    _log.finest(() => 'creating');
  }

  final ICheckpointsManager checkpointsManager;

  @override
  void dispose() {
    _log.finest(() => 'disposing');
    super.dispose();
  }
}
