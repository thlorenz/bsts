import 'package:bsts/core/shared_enums.dart';
import 'package:flutter/material.dart';

void _noop() {}

final GlobalKey<ScaffoldState> homePageScaffoldKey = GlobalKey<ScaffoldState>();
final GlobalKey<ScaffoldState> addRepoPageScaffoldKey =
    GlobalKey<ScaffoldState>();

ScaffoldState _scaffold(BuildContext context) {
  final localScaffold = Scaffold.of(context, nullOk: true);
  return localScaffold ??
      homePageScaffoldKey.currentState ??
      addRepoPageScaffoldKey.currentState;
}

class UndoSnackbar {
  UndoSnackbar({
    @required this.scaffold,
    @required this.message,
    this.hideCurrentSnackbar = true,
    this.undoLabel = 'Undo',
    this.onrequestUndo = _noop,
    Duration duration,
  }) {
    this.duration = duration ?? Duration(seconds: 3);
    _requestedUndo = false;
  }

  final ScaffoldState scaffold;
  final String message;
  final String undoLabel;
  final bool hideCurrentSnackbar;
  final Function onrequestUndo;
  Duration duration;

  bool _requestedUndo;

  Future<bool> show() async {
    if (hideCurrentSnackbar) {
      scaffold.hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
    }

    ScaffoldFeatureController<SnackBar, SnackBarClosedReason> undo;
    undo = scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: SnackBarAction(
          label: undoLabel,
          onPressed: () {
            _requestedUndo = true;
            onrequestUndo();
            undo.close();
          },
        ),
      ),
    );
    await undo.closed;
    return _requestedUndo;
  }
}

void refreshSnackBarIf(bool condition, BuildContext context, String text,
    [EventImportance importance = EventImportance.medium]) {
  if (condition) refreshSnackBar(context, text, importance);
}

int _millisecondsFromImportance(EventImportance importance) {
  switch (importance) {
    case EventImportance.high:
      return 4000;
    case EventImportance.medium:
      return 2000;
    case EventImportance.low:
      return 500;
    default:
      throw ArgumentError('Unknown event importance $importance');
  }
}

void refreshSnackBar(BuildContext context, String text,
    [EventImportance importance = EventImportance.medium]) {
  _scaffold(context)
    ..hideCurrentSnackBar(reason: SnackBarClosedReason.hide)
    ..showSnackBar(SnackBar(
      content: Text(text),
      duration: Duration(milliseconds: _millisecondsFromImportance(importance)),
    ));
}

void showUndoSnackBar(BuildContext context, String text, Function onrequestUndo,
    [int milliseconds = 2500]) {
  UndoSnackbar(
    scaffold: _scaffold(context),
    message: text,
    duration: Duration(milliseconds: milliseconds),
    onrequestUndo: onrequestUndo,
  ).show();
}
