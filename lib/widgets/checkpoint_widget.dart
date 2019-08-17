import 'package:bsts/models/checkpoint.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meta/meta.dart';

class CheckpointWidget extends StatelessWidget {
  const CheckpointWidget({
    @required this.checkpoint,
    Key key,
    this.onTap,
    this.lastCheck,
    this.checked = false,
    this.labelFontSize = 24,
    this.iconSize = 80,
    this.iconTopPadding = 0,
    this.borderSide,
    this.editing = false,
    this.onMoveForward,
    this.onMoveBackward,
    this.onDelete,
  }) : super(key: key);

  final GestureTapCallback onTap;
  final Checkpoint checkpoint;
  final bool checked;
  final String lastCheck;
  final double labelFontSize;
  final double iconSize;
  final double iconTopPadding;
  final BorderSide borderSide;

  final bool editing;
  final GestureTapCallback onMoveForward;
  final GestureTapCallback onMoveBackward;
  final GestureTapCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderSide = this.borderSide ??
        (editing || checked
            ? BorderSide(width: 2, color: Colors.white24)
            : BorderSide(width: 2, color: Colors.orangeAccent));
    final tile = _CheckpointTile(
      checkpoint: checkpoint,
      labelFontSize: labelFontSize,
      iconTopPadding: iconTopPadding,
      iconSize: iconSize,
      checked: checked,
      lastCheck: lastCheck,
      onMoveForward: onMoveForward,
      onMoveBackward: onMoveBackward,
      onDelete: onDelete,
      editing: editing,
    );

    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(
          top: borderSide,
          right: borderSide,
          bottom: borderSide,
          left: borderSide,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              child: tile,
            )
          : tile,
    );
  }
}

class _CheckpointTile extends StatelessWidget {
  const _CheckpointTile({
    Key key,
    @required this.checkpoint,
    this.lastCheck,
    this.checked = false,
    this.labelFontSize = 24,
    this.iconSize = 80,
    this.iconTopPadding = 0,
    this.editing = false,
    this.onMoveBackward,
    this.onMoveForward,
    this.onDelete,
  }) : super(key: key);

  final Checkpoint checkpoint;
  final double labelFontSize;
  final double iconTopPadding;
  final double iconSize;
  final bool checked;
  final String lastCheck;
  final bool editing;
  final GestureTapCallback onMoveForward;
  final GestureTapCallback onMoveBackward;
  final GestureTapCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = Icon(
      IconData(
        checkpoint.iconCodePoint,
        fontPackage: checkpoint.iconFontPackage,
        fontFamily: checkpoint.iconFontFamily,
      ),
      color: Color(checkpoint.iconColor),
      size: editing ? iconSize * 0.5 : iconSize,
    );
    return GridTile(
      header: Text(
        checkpoint.label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: theme.primaryTextTheme.headline.color,
          fontSize: labelFontSize,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: iconTopPadding),
        child: icon,
      ),
      footer: editing ? _editingFooter() : _nonEditingFooter(theme),
    );
  }

  Widget _editingFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap: onMoveBackward,
          child: Icon(
            FontAwesomeIcons.chevronCircleLeft,
            size: 35,
          ),
        ),
        InkWell(
          onTap: onDelete,
          child: Icon(
            Icons.delete,
            size: 35,
            color: Colors.red,
          ),
        ),
        InkWell(
          onTap: onMoveForward,
          child: Icon(
            FontAwesomeIcons.chevronCircleRight,
            size: 35,
          ),
        ),
      ],
    );
  }

  Widget _nonEditingFooter(ThemeData theme) {
    return checked
        ? Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Icon(Icons.check, color: Colors.greenAccent),
            Text(
              lastCheck,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: checked
                    ? Colors.greenAccent
                    : theme.primaryTextTheme.subhead.color,
                fontSize: 18,
              ),
            ),
          ])
        : null;
  }
}
