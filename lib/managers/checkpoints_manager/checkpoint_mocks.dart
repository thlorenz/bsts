import 'package:bsts/models/checkpoint.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CheckpointMocks {
  static Checkpoint create(
    String id,
    IconData icon,
    Color iconColor,
    Duration lastCheck,
  ) {
    return Checkpoint(
      id: id,
      iconCodePoint: icon.codePoint,
      iconFontPackage: icon.fontPackage,
      iconFontFamily: icon.fontFamily,
      iconColor: iconColor.value,
      lastCheck: lastCheck != null ? DateTime.now().subtract(lastCheck) : null,
      label: id,
    );
  }

  static Checkpoint oven =
      create('Oven', Icons.kitchen, Colors.brown, Duration(minutes: 10));
  static Checkpoint water =
      create('Water', FontAwesomeIcons.water, Colors.blue, null);
  static Checkpoint electricity =
      create('Unplug Heater', FontAwesomeIcons.plug, Colors.black, null);
  static Checkpoint lockdoor = create(
      'Lock Door', FontAwesomeIcons.key, Colors.blueGrey, Duration(minutes: 5));
  static Checkpoint closedoor = create('Close Door', FontAwesomeIcons.doorOpen,
      Colors.brown, Duration(minutes: 2));
  static Checkpoint tv =
      create('Turn off TV', FontAwesomeIcons.tv, Colors.grey, null);
  static Checkpoint window = create('Close Windows', FontAwesomeIcons.home,
      Colors.lightBlue, Duration(minutes: 15));

  static List<Checkpoint> allCheckpoints = [
    oven,
    water,
    electricity,
    lockdoor,
    closedoor,
    tv,
    window,
  ];
}
