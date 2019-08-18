import 'package:bsts/models/checkpoint.dart';
import 'package:flutter/material.dart';
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
  }) : super(key: key);

  final GestureTapCallback onTap;
  final Checkpoint checkpoint;
  final bool checked;
  final String lastCheck;
  final double labelFontSize;
  final double iconSize;
  final double iconTopPadding;
  final BorderSide borderSide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderSide = this.borderSide ??
        (checked
            ? BorderSide(width: 2, color: Colors.white24)
            : BorderSide(width: 2, color: Colors.orangeAccent));
    final tile = _CheckpointTile(
      checkpoint: checkpoint,
      labelFontSize: labelFontSize,
      iconTopPadding: iconTopPadding,
      iconSize: iconSize,
      checked: checked,
      lastCheck: lastCheck,
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
  }) : super(key: key);

  final Checkpoint checkpoint;
  final double labelFontSize;
  final double iconTopPadding;
  final double iconSize;
  final bool checked;
  final String lastCheck;

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
      size: iconSize,
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
      footer: _footer(theme),
    );
  }

  Widget _footer(ThemeData theme) {
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
