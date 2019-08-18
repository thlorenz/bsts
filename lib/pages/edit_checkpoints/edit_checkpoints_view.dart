import 'package:bsts/bloc/edit_checkpoints/edit_checkpoints_bloc.dart';
import 'package:bsts/models/checkpoint.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditCheckpointsView extends StatelessWidget {
  const EditCheckpointsView({this.state});
  final EditCheckpointsState state;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<EditCheckpointsBloc>(context);
    final tiles = state.checkpoints
        .map((cp) => _CheckpointListTile(
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

class _CheckpointListTile extends StatelessWidget {
  const _CheckpointListTile({this.checkpoint, Key key}) : super(key: key);
  final Checkpoint checkpoint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderSide = BorderSide(width: 2, color: Colors.white24);
    return Container(
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(
          top: borderSide,
          right: borderSide,
          bottom: borderSide,
          left: borderSide,
        ),
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      child: ListTile(
        leading: Icon(
          IconData(
            checkpoint.iconCodePoint,
            fontPackage: checkpoint.iconFontPackage,
            fontFamily: checkpoint.iconFontFamily,
          ),
          color: Color(checkpoint.iconColor),
          size: 30,
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(checkpoint.label),
        ),
        trailing: Icon(Icons.reorder),
      ),
    );
  }
}
