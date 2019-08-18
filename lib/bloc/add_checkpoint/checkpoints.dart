import 'package:bsts/models/checkpoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Checkpoint _c(String label, IconData icon, Color iconColor) {
  return Checkpoint(
    id: '$label.${icon.codePoint}.${icon.fontFamily}.'
        '${icon.fontPackage}.${iconColor.value}',
    label: label,
    iconCodePoint: icon.codePoint,
    iconFontPackage: icon.fontPackage,
    iconFontFamily: icon.fontFamily,
    iconColor: iconColor.value,
    lastCheck: null,
  );
}

Iterable<Checkpoint> get _kitchen sync* {
  yield _c('Oven', Icons.kitchen, Colors.brown);
  yield _c('Fridge', FontAwesomeIcons.snowflake, Colors.white);
  yield _c('Sink', FontAwesomeIcons.water, Colors.blue);
  yield _c('Gas', FontAwesomeIcons.fireAlt, Colors.blue);
  yield _c('Coffemaker', FontAwesomeIcons.coffee, Colors.black);
  yield _c('Blender', FontAwesomeIcons.blender, Colors.lightBlueAccent);
}

Iterable<Checkpoint> get _bath sync* {
  yield _c('Shower', FontAwesomeIcons.shower, Colors.blue);
  yield _c('Bathtub', FontAwesomeIcons.bath, Colors.white);
  yield _c('Hottub', FontAwesomeIcons.hotTub, Colors.brown);
  yield _c('Toilet', FontAwesomeIcons.toilet, Colors.white);
  yield _c('Sink', FontAwesomeIcons.water, Colors.blue);
}

Iterable<Checkpoint> get _house sync* {
  yield _c('Heater', FontAwesomeIcons.temperatureHigh, Colors.red);
  yield _c('Fan', FontAwesomeIcons.fan, Colors.grey);
  yield _c('Light', FontAwesomeIcons.lightbulb, Colors.yellowAccent);
  yield _c('TV', FontAwesomeIcons.tv, Colors.grey);
  yield _c('Clock', FontAwesomeIcons.clock, Colors.brown);
  yield _c('Wifi', FontAwesomeIcons.wifi, Colors.white);
  yield _c('Curtains', FontAwesomeIcons.personBooth, Colors.grey);
  yield _c('Window', FontAwesomeIcons.building, Colors.lightBlueAccent);
  yield _c('Door', FontAwesomeIcons.doorOpen, Colors.brown);
  yield _c('Gate', FontAwesomeIcons.toriiGate, Colors.brown);
  yield _c('Garage Door', FontAwesomeIcons.warehouse, Colors.grey);
  yield _c('Plants', FontAwesomeIcons.seedling, Colors.green);
  yield _c('Car', FontAwesomeIcons.warehouse, Colors.blueGrey);
  yield _c('Motorcycle', FontAwesomeIcons.motorcycle, Colors.blueGrey);
  yield _c('Bicycle', FontAwesomeIcons.biking, Colors.blueGrey);
  yield _c('Dumpster', FontAwesomeIcons.dumpster, Colors.grey);
  yield _c('Trash', FontAwesomeIcons.trashAlt, Colors.grey);
}

Iterable<Checkpoint> get _pets sync* {
  yield _c('Cat', FontAwesomeIcons.cat, Colors.black);
  yield _c('Dog', FontAwesomeIcons.dog, Colors.brown);
  yield _c('Horse', FontAwesomeIcons.horse, Colors.white);
  yield _c('Bird', FontAwesomeIcons.kiwiBird, Colors.yellow);
  yield _c('Fish', FontAwesomeIcons.fish, Colors.grey);
  yield _c('Spider', FontAwesomeIcons.spider, Colors.brown);
  yield _c('Frog', FontAwesomeIcons.frog, Colors.green);
}

Iterable<Checkpoint> get _things sync* {
  // More in business
  yield _c('Wallet', FontAwesomeIcons.wallet, Colors.black);
  yield _c('Glasses', FontAwesomeIcons.glasses, Colors.black);
  yield _c('Map', FontAwesomeIcons.map, Colors.green);
  yield _c('Binoculars', FontAwesomeIcons.binoculars, Colors.black);
  yield _c('First Aid', FontAwesomeIcons.firstAid, Colors.red);
  yield _c('Camera', FontAwesomeIcons.camera, Colors.black);
  yield _c('Phone', FontAwesomeIcons.mobileAlt, Colors.black);
  yield _c('Laptop', FontAwesomeIcons.laptop, Colors.blue);
  yield _c('Computer', FontAwesomeIcons.desktop, Colors.grey);
  yield _c('Printer', FontAwesomeIcons.print, Colors.white);
  yield _c('Headphones', FontAwesomeIcons.headphones, Colors.black);
  yield _c('Tools', FontAwesomeIcons.tools, Colors.grey);
  yield _c('Book', FontAwesomeIcons.book, Colors.brown);
  yield _c('Charger', FontAwesomeIcons.batteryHalf, Colors.black);
  yield _c('Toilet Paper', FontAwesomeIcons.toiletPaper, Colors.white);
  yield _c('Eye Dropper', FontAwesomeIcons.eyeDropper, Colors.blue);
  yield _c('Newspaper', FontAwesomeIcons.newspaper, Colors.black);
  yield _c('Scissors', FontAwesomeIcons.cut, Colors.blueGrey);
  yield _c('Bathing Suit', FontAwesomeIcons.swimmer, Colors.blue);
  yield _c('Tent', FontAwesomeIcons.campground, Colors.orange);
  yield _c('Teeth', FontAwesomeIcons.teethOpen, Colors.white);
}

List<Checkpoint> _combine(List<List<Checkpoint>> lists) {
  final ids = <String>{};
  final all = <Checkpoint>[];
  for (final list in lists) {
    for (final item in list) {
      if (ids.contains(item.id)) continue;
      ids.add(item.id);
      all.add(item);
    }
  }
  return all;
}

@immutable
class Category {
  const Category(this.label, this.icon, this.color, this.checkpoints);
  final String label;
  final IconData icon;
  final Color color;
  final List<Checkpoint> checkpoints;
}

class Checkpoints {
  static List<Checkpoint> kitchen = _kitchen.toList();
  static List<Checkpoint> bath = _bath.toList();
  static List<Checkpoint> house = _house.toList();
  static List<Checkpoint> pets = _pets.toList();
  static List<Checkpoint> things = _things.toList();

  static final List<Category> categories = <Category>[
    Category(
      'Kitchen',
      FontAwesomeIcons.blender,
      Colors.cyanAccent,
      kitchen,
    ),
    Category('Bath', FontAwesomeIcons.bath, Colors.lightBlue, bath),
    Category('House', FontAwesomeIcons.home, Colors.brown, house),
    Category('Pets', FontAwesomeIcons.dog, Colors.orangeAccent, pets),
    Category('Various', FontAwesomeIcons.icons, Colors.grey, things),
    Category('Custom', FontAwesomeIcons.edit, Colors.white, null),
  ];

  static List<Checkpoint> all = _combine([kitchen, bath, house, pets]);
}
