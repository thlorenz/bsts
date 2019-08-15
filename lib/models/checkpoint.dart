import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Checkpoint extends Equatable {
  Checkpoint({
    @required this.id,
    @required this.iconCodePoint,
    @required this.iconFontFamily,
    @required this.iconFontPackage,
    @required this.iconColor,
    @required this.label,
    @required this.lastCheck,
  }) : super(<dynamic>[
          id,
          iconCodePoint,
          iconFontPackage,
          iconFontFamily,
          label,
          lastCheck,
        ]);

  final String id;
  final int iconCodePoint;
  final String iconFontFamily;
  final String iconFontPackage;
  final int iconColor;
  final String label;
  final DateTime lastCheck;

  Checkpoint copyWith({
    String id,
    int iconCodePoint,
    String iconFontPackage,
    String iconFontFamily,
    int iconColor,
    String label,
  }) {
    return Checkpoint(
      id: id ?? this.id,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      iconFontPackage: iconFontPackage ?? this.iconFontPackage,
      iconFontFamily: iconFontFamily ?? this.iconFontFamily,
      iconColor: iconColor ?? this.iconColor,
      label: label ?? this.label,
      lastCheck: lastCheck,
    );
  }

  Checkpoint updateLastCheck(DateTime lastCheck) {
    return Checkpoint(
      id: id,
      iconCodePoint: iconCodePoint,
      iconFontPackage: iconFontPackage,
      iconFontFamily: iconFontFamily,
      iconColor: iconColor,
      label: label,
      lastCheck: lastCheck,
    );
  }

  String toString() {
    return '''Checkpoint{
       id: $id,
       label: $label,
       lastCheck: $lastCheck 
     }''';
  }
}
