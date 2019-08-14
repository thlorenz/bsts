import 'package:bsts/bloc/checkpoint/checkpoint_bloc.dart';
import 'package:bsts/bloc/checkpoint/checkpoint_bloc.ui.dart';
import 'package:bsts/bloc/checkpoints/checkpoints_state.dart';
import 'package:bsts/packages/se_bloc/factories.dart';
import 'package:bsts/pages/home_page/checkpoint_view.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class CheckpointsView extends StatelessWidget {
  const CheckpointsView({@required this.state});
  final CheckpointsState state;

  static Widget providedState(CheckpointsState checkpointsState) {
    assert(checkpointsState != null);
    return CheckpointsView(state: checkpointsState);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: state.checkpoints != null ? state.checkpoints.length : 0,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (ctx, idx) =>
          blocProvider<CheckpointBloc, CheckpointState, CheckpointEvent>(
        context,
        checkpointBlocBuilder(context, state.checkpoints[idx].id),
        _onCheckpointChanged,
        CheckpointView.stateToView,
      ),
    );
  }

  void _onCheckpointChanged(
    BuildContext context,
    CheckpointBloc bloc,
    CheckpointEvent event,
  ) {}
}
