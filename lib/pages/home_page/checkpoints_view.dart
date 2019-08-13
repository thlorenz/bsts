import 'package:bsts/bloc/checkpoints/checkpoints_state.dart';
import 'package:bsts/models/checkpoint.dart';
import 'package:bsts/pages/home_page/checkpoint_view.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class CheckpointsView extends StatelessWidget {
  const CheckpointsView({@required this.checkpoints});
  final List<Checkpoint> checkpoints;

  static Widget providedState(CheckpointsState checkpointsState) {
    return CheckpointsView(
      checkpoints: checkpointsState.checkpoints,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: checkpoints != null ? checkpoints.length : 0,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (ctx, idx) => CheckpointView(
        checkpoint: checkpoints[idx],
        key: Key(checkpoints[idx].id),
      ),
    );
  }
}
