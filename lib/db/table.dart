import 'package:bsts/models/checkpoint.dart';
import 'package:sqflite/sqflite.dart';

// ignore: unused_element
DateTime _date(Map<String, dynamic> row, String columnID) {
  return DateTime.fromMillisecondsSinceEpoch(row[columnID] as int);
}

const String CREATE_TABLE_SQL = '''
CREATE TABLE IF NOT EXISTS ${Table.table} (
);
''';

class Table {
  static const String table = 'main';
  static const String id = 'id';

  static List<String> columns = [
    id,
  ];

  static Future<void> create(Database db) {
    return db.execute(CREATE_TABLE_SQL);
  }

  static Map<String, dynamic> row(Checkpoint checkpoint) {
    return <String, dynamic>{
      Table.id: checkpoint.id,
    };
  }

  static Checkpoint fromRow(Map<String, dynamic> row) {
    return Checkpoint(
      id: row[Table.id] as String,
    );
  }
}
