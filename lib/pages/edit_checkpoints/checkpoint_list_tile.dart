import 'package:bsts/bloc/edit_checkpoints/edit_checkpoints_bloc.dart';
import 'package:bsts/models/checkpoint.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CheckpointListTile extends StatelessWidget {
  CheckpointListTile({this.checkpoint, Key key}) : super(key: key);
  final Checkpoint checkpoint;
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = Provider.of<EditCheckpointsBloc>(context);

    final label = Text(
      checkpoint.label,
      style: TextStyle(color: Colors.black),
    );
    return Container(
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.fromBorderSide(
          BorderSide(width: 2, color: Colors.white24),
        ),
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      child: Dismissible(
        key: Key(checkpoint.id),
        onDismissed: (_) => bloc.remove(checkpoint.id),
        background: _DismissableBackground(),
        direction: DismissDirection.endToStart,
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
          title: InkWell(
            onTap: () async {
              final String label = await _displayDialog(context) as String;
              if (label != null) bloc.updateLabel(checkpoint.id, label);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: _LabelContainer(label: label, padding: 4),
            ),
          ),
          trailing: Icon(Icons.reorder),
        ),
      ),
    );
  }

  Future<void> _displayDialog(BuildContext context) async {
    _textFieldController.text = checkpoint.label;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              decoration: InputDecoration(
                focusColor: Colors.blue,
                helperText: 'Checkpoint Label',
              ),
              autofocus: true,
              autocorrect: false,
              style: TextStyle(
                fontSize: 20,
              ),
              controller: _textFieldController,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
              ),
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  final s = _textFieldController.text;
                  Navigator.of(context).pop(s.isNotEmpty ? s : null);
                },
              ),
            ],
          );
        });
  }
}

class _LabelContainer extends StatelessWidget {
  const _LabelContainer({
    Key key,
    @required this.label,
    this.padding,
  }) : super(key: key);

  final Widget label;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.fromBorderSide(
          BorderSide(width: 1, color: Colors.white70),
        ),
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      child: padding != null
          ? Padding(
              padding: EdgeInsets.all(padding),
              child: label,
            )
          : label,
    );
  }
}

class _DismissableBackground extends StatelessWidget {
  const _DismissableBackground({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      padding: EdgeInsets.only(right: 10),
      alignment: Alignment.centerRight,
      child: Icon(
        FontAwesomeIcons.trashAlt,
        color: Colors.grey.shade300,
        size: 30,
      ),
    );
  }
}
