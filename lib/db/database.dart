import 'dart:io';

import 'package:bsts/core/interfaces.dart';
import 'package:bsts/core/log.dart';
import 'package:bsts/db/table.dart';
import 'package:bsts/models/checkpoint.dart';
import 'package:sqflite/sqflite.dart';

const int DATABASE_VERSION = 1;

final Log<BstsDatabase> _log = Log();

abstract class IDatabase<T> implements IDisposable {
  Future<void> drop();
  Future<Iterable<T>> getAll();
  Future<void> upsert(T repo);
  Future<int> delete(String id);
}

class BstsDatabase implements IDatabase<Checkpoint> {
  BstsDatabase(this.databasePath);

  final String databasePath;
  Database _db;

  Future<void> init() async {
    _log.info(() => 'Initializing database at $databasePath');
    _db = await openDatabase(
      databasePath,
      version: DATABASE_VERSION,
      onConfigure: _ondatabaseConfigure,
      onCreate: _ondatabaseCreate,
    );
  }

  Future<void> drop() async {
    if (_db.isOpen) await _db.close();
    _log.info(() => 'Deleting database at $databasePath');
    await File(databasePath).delete();
    return init();
  }

  Future<Iterable<Checkpoint>> getAll() async {
    final repoRows = await _db.query(
      Table.table,
      columns: Table.columns,
    );
    final repos = repoRows.map(Table.fromRow);
    _log.finest('Retrieved repos $repos');
    return repos;
  }

  Future<void> upsert(Checkpoint checkpoint) async {
    _log.finer(() => 'Inserting ${checkpoint.id}');
    return _db.insert(
      Table.table,
      Table.row(checkpoint),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> delete(String id) {
    _log.finer(() => 'Deleting $id');
    return _db.delete(
      Table.table,
      where: '${Table.id} = ?',
      whereArgs: <String>[id],
    );
  }

  Future<void> _ondatabaseConfigure(Database db) {
    return db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _ondatabaseCreate(Database db, int version) async {
    return Table.create(db);
  }

  void dispose() {
    if (_db != null && !_db.isOpen) _db.close();
  }
}
