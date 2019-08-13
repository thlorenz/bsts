import 'package:bsts/models/checkpoint.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:timeago/timeago.dart' as timeago;

class CheckpointView extends StatelessWidget {
  const CheckpointView({
    @required this.checkpoint,
    @required Key key,
  }) : super(key: key);
  final Checkpoint checkpoint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final checked = checkpoint.lastCheck != null;
    final lastCheck = checked ? timeago.format(checkpoint.lastCheck) : null;
    final borderSide = BorderSide(width: 1, color: Colors.white24);
    return Opacity(
      opacity: checked ? 0.5 : 1.0,
      child: Container(
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
        child: GridTile(
            header: Text(
              checkpoint.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.primaryTextTheme.headline.color,
                fontSize: 24,
              ),
            ),
            child: Icon(
              IconData(
                checkpoint.iconCodePoint,
                fontPackage: checkpoint.iconFontPackage,
                fontFamily: checkpoint.iconFontFamily,
              ),
              color: Color(checkpoint.iconColor),
              size: 80,
            ),
            footer: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: checked
                  ? <Widget>[
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
                    ]
                  : [],
            )),
      ),
    );
  }
}
