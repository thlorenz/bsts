import 'package:bsts/bloc/checkpoint/checkpoint_bloc.dart';
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
    final theme = Theme.of(context);
    final bloc = Provider.of<CheckpointBloc>(context);
    final checkpoint = state.checkpoint;
    final borderSide = state.checked
        ? BorderSide(width: 2, color: Colors.white24)
        : BorderSide(width: 2, color: Colors.orangeAccent);
    return Opacity(
      opacity: state.checked ? 0.6 : 1.0,
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
        child: InkWell(
          onTap: bloc.verify,
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
                children: state.checked
                    ? <Widget>[
                        Icon(Icons.check, color: Colors.greenAccent),
                        Text(
                          state.lastCheck,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: state.checked
                                ? Colors.greenAccent
                                : theme.primaryTextTheme.subhead.color,
                            fontSize: 18,
                          ),
                        ),
                      ]
                    : [],
              )),
        ),
      ),
    );
  }
}
