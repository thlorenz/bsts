import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class ModifyViewDecorator extends StatelessWidget {
  const ModifyViewDecorator({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final borderSide = BorderSide(width: 1, color: Colors.white70);
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border(
          top: borderSide,
          right: borderSide,
          bottom: borderSide,
          left: borderSide,
        ),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: child,
    );
  }
}
