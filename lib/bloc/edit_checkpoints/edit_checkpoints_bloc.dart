import 'dart:async';

import 'package:bsts/bloc/edit_checkpoints/edit_checkpoints_event.dart';
import 'package:bsts/bloc/edit_checkpoints/edit_checkpoints_state.dart';
import 'package:bsts/core/log.dart';
import 'package:bsts/managers/checkpoints_manager/checkpoints_manager.dart';
import 'package:bsts/packages/se_bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

export 'package:bsts/bloc/edit_checkpoints/edit_checkpoints_event.dart';
export 'package:bsts/bloc/edit_checkpoints/edit_checkpoints_state.dart';

final _log = Log<EditCheckpointsBloc>();

class EditCheckpointsBloc
    extends BlocBase<EditCheckpointsState, EditCheckpointsEvent> {
  EditCheckpointsBloc({
    @required this.checkpointsManager,
    InspectItem<EditCheckpointsState> inspectState,
    InspectItem<EditCheckpointsEvent> inspectEvent,
  }) : super(
          initialState: EditCheckpointsState.initial(
            checkpointsManager.checkpoints,
          ),
          inspectState: inspectState,
          inspectEvent: inspectEvent,
        ) {
    _log.finest(() => 'creating');

    _checkpointsChangedSub = Observable.merge([
      checkpointsManager.checkpointsChanged$,
      checkpointsManager.checkpointChanged$.mapTo<void>(null),
    ]).listen(_onCheckpointsChanged);
  }

  final ICheckpointsManager checkpointsManager;
  StreamSubscription<void> _checkpointsChangedSub;

  void reorder(int oldIdx, int newIdx) {
    checkpointsManager.reorder(oldIdx, newIdx);
  }

  void updateLabel(String id, String label) {
    checkpointsManager.updateLabel(id, label);
  }

  void _onCheckpointsChanged(void _) {
    state(
      EditCheckpointsState.changed(
        currentState,
        checkpointsManager.checkpoints,
      ),
    );
  }

  @override
  void dispose() {
    _log.finest(() => 'disposing');
    _checkpointsChangedSub?.cancel();
    super.dispose();
  }
}
