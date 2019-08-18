import 'package:bsts/bloc/edit_checkpoints/edit_checkpoints_bloc.dart';
import 'package:bsts/pages/edit_checkpoints/checkpoint_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditCheckpointsView extends StatelessWidget {
  const EditCheckpointsView({this.state});
  final EditCheckpointsState state;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<EditCheckpointsBloc>(context);
    final tiles = state.checkpoints
        .map((cp) => CheckpointListTile(
              checkpoint: cp,
              key: Key(cp.id),
            ))
        .toList();
    return ReorderableListView(
      children: tiles,
      onReorder: bloc.reorder,
      padding: EdgeInsets.all(5),
    );
  }
}
