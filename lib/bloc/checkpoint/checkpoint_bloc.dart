import 'dart:async' as dart_async;
import 'dart:async';

import 'package:bsts/bloc/checkpoint/checkpoint_event.dart';
import 'package:bsts/bloc/checkpoint/checkpoint_state.dart';
import 'package:bsts/core/log.dart';
import 'package:bsts/core/timer.dart';
import 'package:bsts/managers/checkpoints_manager/checkpoints_manager.dart';
import 'package:bsts/packages/se_bloc/bloc.dart';
import 'package:meta/meta.dart';

export 'package:bsts/bloc/checkpoint/checkpoint_event.dart';
export 'package:bsts/bloc/checkpoint/checkpoint_state.dart';

final _log = Log<CheckpointBloc>();

class CheckpointBloc extends BlocBase<CheckpointState, CheckpointEvent> {
  CheckpointBloc({
    @required this.id,
    @required this.checkpointsManager,
    @required this.timer,
    InspectItem<CheckpointState> inspectState,
    InspectItem<CheckpointEvent> inspectEvent,
  })  : assert(id != null),
        super(
            initialState: CheckpointState.initial(checkpointsManager.byID(id)),
            inspectState: inspectState,
            inspectEvent: inspectEvent) {
    _log.finest(() => 'creating $id');

    _checkpointChangedSub = checkpointsManager.checkpointChanged$
        .where((id) => id == this.id)
        .listen(_onCheckpointChanged);
    timer.periodic(Duration(minutes: 1), _onTick);
  }

  final ICheckpointsManager checkpointsManager;
  final ITimer timer;
  final String id;

  StreamSubscription<String> _checkpointChangedSub;
  void Function() cancelTick;

  void verify() {
    checkpointsManager.verifyCheckpoint(currentState.checkpoint.id);
  }

  void delete() {
    checkpointsManager.removeCheckpoint(id);
  }

  void _onCheckpointChanged(String id) {
    assert(id == this.id);
    if (checkpointsManager.hasID(id)) {
      state(CheckpointState.changed(currentState, checkpointsManager.byID(id)));
    } else {
      // event() TODO: show removed event
    }
  }

  void _onTick(dart_async.Timer timer) {
    cancelTick = timer.cancel;
    if (currentState.checkpoint.lastCheck == null) return;
    if (!checkpointsManager.hasID(id)) return;
    state(CheckpointState.tick(currentState, checkpointsManager.byID(id)));
  }

  @override
  void dispose() {
    _log.finest(() => 'disposing $id');
    if (cancelTick != null) cancelTick();
    _checkpointChangedSub?.cancel();
    super.dispose();
  }
}
