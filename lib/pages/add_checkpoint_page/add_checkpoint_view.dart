import 'package:bsts/bloc/add_checkpoint/add_checkpoint_bloc.dart';
import 'package:bsts/models/checkpoint.dart';
import 'package:bsts/widgets/checkpoint_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCheckpointView extends StatelessWidget {
  const AddCheckpointView({this.state});
  final AddCheckpointState state;

  static Widget stateToView(BuildContext context, AddCheckpointState state) {
    return AddCheckpointView(state: state);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: state.checkpoints.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (ctx, idx) {
        final checkpoint = state.checkpoints[idx];
        return _AddCheckpointItem(
          checkpoint: checkpoint,
          key: Key(checkpoint.id),
        );
      },
    );
  }
}

class _AddCheckpointItem extends StatelessWidget {
  const _AddCheckpointItem({@required this.checkpoint, Key key})
      : super(key: key);
  final Checkpoint checkpoint;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<AddCheckpointBloc>(context);
    return CheckpointWidget(
      checkpoint: checkpoint,
      labelFontSize: 20,
      iconSize: 60,
      iconTopPadding: 46,
      borderSide: BorderSide(width: 2, color: Colors.white24),
      onTap: () => bloc.addCheckpoint(checkpoint),
    );
  }
}
