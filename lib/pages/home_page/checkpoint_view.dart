import 'package:bsts/bloc/checkpoint/checkpoint_bloc.dart';
import 'package:bsts/widgets/checkpoint_widget.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

class CheckpointView extends StatelessWidget {
  const CheckpointView({
    @required this.state,
    @required Key key,
  }) : super(key: key);
  final CheckpointState state;

  static Widget stateToView(BuildContext context, CheckpointState state) {
    assert(state?.checkpoint != null);
    final key = Key(state.checkpoint.id);
    return CheckpointView(state: state, key: key);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<CheckpointBloc>(context);
    final checkpoint = state.checkpoint;
    final checkpointWidget = CheckpointWidget(
      checkpoint: checkpoint,
      onTap: bloc.verify,
      checked: state.checked,
      lastCheck: state.lastCheck,
    );
    return Draggable<String>(
      data: checkpoint.id,
      maxSimultaneousDrags: 1,
      child:
          Opacity(opacity: state.checked ? 0.6 : 1.0, child: checkpointWidget),
      feedback: Container(
        width: 200,
        height: 200,
        child: CheckpointWidget(checkpoint: checkpoint),
      ),
      childWhenDragging: null,
    );
  }
}
