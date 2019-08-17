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
    final onTap = state.editing ? null : bloc.verify;
    return CheckpointWidget(
      checkpoint: checkpoint,
      onTap: onTap,
      checked: state.checked,
      lastCheck: state.lastCheck,
      editing: state.editing,
      onMoveForward: bloc.moveForward,
      onMoveBackward: bloc.moveBackward,
      onDelete: bloc.delete,
    );
  }
}
