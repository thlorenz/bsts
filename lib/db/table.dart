import 'package:bsts/models/checkpoint.dart';
import 'package:sqflite/sqflite.dart';

DateTime _date(Map<String, dynamic> row, String columnID) {
  final n = row[columnID] as int;
  return n == null ? null : DateTime.fromMillisecondsSinceEpoch(n);
}

const String CREATE_TABLE_SQL = '''
CREATE TABLE IF NOT EXISTS ${CheckpointTable.table} (
  ${CheckpointTable.id}              text PRIMARY KEY NOT NULL,
  ${CheckpointTable.iconCodePoint}   integer NOT NULL,
  ${CheckpointTable.iconFontPackage} text NOT NULL,
  ${CheckpointTable.iconFontFamily}  text NOT NULL,
  ${CheckpointTable.iconColor}       integer NOT NULL,
  ${CheckpointTable.label}           text NOT NULL,
  ${CheckpointTable.lastCheck}       integer
);
''';

class CheckpointTable {
  static const String table = 'main';
  static const String id = 'id';
  static const String iconCodePoint = 'iconCodePoint';
  static const String iconFontPackage = 'iconFontPackage';
  static const String iconFontFamily = 'iconFontFamily';
  static const String iconColor = 'iconColor';
  static const String label = 'label';
  static const String lastCheck = 'lastCheck';

  static List<String> columns = [
    id,
    iconCodePoint,
    iconFontPackage,
    iconFontFamily,
    iconColor,
    label,
    lastCheck,
  ];

  static Future<void> create(Database db) {
    return db.execute(CREATE_TABLE_SQL);
  }

  static Map<String, dynamic> row(Checkpoint checkpoint) {
    return <String, dynamic>{
      CheckpointTable.id: checkpoint.id,
      CheckpointTable.iconCodePoint: checkpoint.iconCodePoint,
      CheckpointTable.iconFontPackage: checkpoint.iconFontPackage,
      CheckpointTable.iconFontFamily: checkpoint.iconFontFamily,
      CheckpointTable.iconColor: checkpoint.iconColor,
      CheckpointTable.label: checkpoint.label,
      CheckpointTable.lastCheck: checkpoint.lastCheck,
    };
  }

  static Checkpoint fromRow(Map<String, dynamic> row) {
    return Checkpoint(
        id: row[CheckpointTable.id] as String,
        iconCodePoint: row[CheckpointTable.iconCodePoint] as int,
        iconFontPackage: row[CheckpointTable.iconFontPackage] as String,
        iconFontFamily: row[CheckpointTable.iconFontFamily] as String,
        iconColor: row[CheckpointTable.iconColor] as int,
        label: row[CheckpointTable.label] as String,
        lastCheck: _date(row, CheckpointTable.lastCheck));
  }
}
