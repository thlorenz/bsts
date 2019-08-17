import 'dart:async';

import 'package:bsts/bloc/checkpoints/checkpoints_event.dart';
import 'package:bsts/bloc/checkpoints/checkpoints_state.dart';
import 'package:bsts/core/log.dart';
import 'package:bsts/managers/checkpoints_manager/checkpoints_manager.dart';
import 'package:bsts/models/checkpoint.dart';
import 'package:bsts/packages/se_bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

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
            false,
          ),
          inspectState: inspectState,
          inspectEvent: inspectEvent,
        ) {
    _log.finest(() => 'creating');

    _checkpointsChangedSub = Observable.merge([
      checkpointsManager.checkpointsChanged$,
      checkpointsManager.checkpointChanged$.mapTo<void>(null),
    ]).listen(_onCheckpointsChanged);

    _editModeToggledSub =
        checkpointsManager.editModeToggled$.listen(_onEditModeToggled);
  }

  final ICheckpointsManager checkpointsManager;
  StreamSubscription<void> _checkpointsChangedSub;
  StreamSubscription<bool> _editModeToggledSub;

  void reset() {
    _log.info('resetting');
    checkpointsManager.resetAll();
  }

  void toggleUnverified() {
    final filteringUnverified = !currentState.filteringUnverified;
    state(CheckpointsState.filterChanged(
      currentState,
      _checkpoints(filteringUnverified),
      filteringUnverified,
    ));
  }

  void Function() get toggleEditMode => checkpointsManager.toggleEditMode;

  void _onCheckpointsChanged(void _) {
    state(
      CheckpointsState.changed(currentState, _checkpoints()),
    );
  }

  void _onEditModeToggled(bool editing) {
    state(CheckpointsState.editToggled(currentState, editing));
  }

  List<Checkpoint> _checkpoints([bool filteringUnverifiedParam]) {
    final filteringUnverified =
        filteringUnverifiedParam ?? currentState.filteringUnverified;
    final allCheckpoints = checkpointsManager.checkpoints;
    return filteringUnverified
        ? allCheckpoints.where((x) => x.lastCheck == null).toList()
        : allCheckpoints;
  }

  @override
  void dispose() {
    _log.finest(() => 'disposing');
    _checkpointsChangedSub?.cancel();
    _editModeToggledSub?.cancel();
    super.dispose();
  }
}
