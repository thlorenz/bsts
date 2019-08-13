import 'dart:io';

import 'package:bsts/core/interfaces.dart';
import 'package:bsts/core/log.dart';
import 'package:bsts/db/table.dart';
import 'package:bsts/models/checkpoint.dart';
import 'package:sqflite/sqflite.dart';

const int DATABASE_VERSION = 1;

final Log<BstsDatabase> _log = Log();

abstract class IDatabase implements IDisposable {
  Future<void> drop();
  Future<List<Checkpoint>> getCheckpoints();
  Future<void> upsertCheckpoint(Checkpoint repo);
  Future<int> deleteCheckpoint(String id);
}

class BstsDatabase implements IDatabase {
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

  Future<List<Checkpoint>> getCheckpoints() async {
    final repoRows = await _db.query(
      CheckpointTable.table,
      columns: CheckpointTable.columns,
    );
    final repos = repoRows.map(CheckpointTable.fromRow);
    _log.finest('Retrieved repos $repos');
    return repos.toList();
  }

  Future<void> upsertCheckpoint(Checkpoint checkpoint) async {
    _log.finer(() => 'Inserting ${checkpoint.id}');
    return _db.insert(
      CheckpointTable.table,
      CheckpointTable.row(checkpoint),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteCheckpoint(String id) {
    _log.finer(() => 'Deleting $id');
    return _db.delete(
      CheckpointTable.table,
      where: '${CheckpointTable.id} = ?',
      whereArgs: <String>[id],
    );
  }

  Future<void> _ondatabaseConfigure(Database db) {
    return db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _ondatabaseCreate(Database db, int version) async {
    return CheckpointTable.create(db);
  }

  void dispose() {
    if (_db != null && !_db.isOpen) _db.close();
  }
}
