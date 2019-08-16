import 'package:bsts/core/tuple.dart';
import 'package:sqflite/sqflite.dart';

const String CREATE_TABLE_SQL = '''
CREATE TABLE IF NOT EXISTS ${MetadataTable.table} (
  ${MetadataTable.key}    text PRIMARY KEY NOT NULL,
  ${MetadataTable.value}  text NOT NULL
);
''';

class MetadataTable {
  static const String table = 'metadata';
  static const String key = 'key';
  static const String value = 'value';

  static List<String> columns = [key, value];

  static Future<void> create(Database db) {
    return db.execute(CREATE_TABLE_SQL);
  }

  static Map<String, dynamic> row(Tuple<String, String> keyVal) {
    return <String, dynamic>{
      MetadataTable.key: keyVal.first,
      MetadataTable.value: keyVal.second
    };
  }

  static Tuple<String, String> fromRow(Map<String, dynamic> row) {
    return Tuple(
      row[MetadataTable.key] as String,
      row[MetadataTable.value] as String,
    );
  }

  static Map<String, dynamic> listRow(Tuple<String, List<String>> keyVal) {
    return <String, dynamic>{
      MetadataTable.key: keyVal.first,
      MetadataTable.value: keyVal.second.join(','),
    };
  }

  static Tuple<String, List<String>> listFromRow(Map<String, dynamic> row) {
    final val = row[MetadataTable.value] as String;
    final list = val == null || val.isEmpty ? <String>[] : val.split(',');
    return Tuple(
      row[MetadataTable.key] as String,
      list,
    );
  }
}
