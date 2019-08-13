import 'dart:io';

import 'package:bsts/core/interfaces.dart';
import 'package:bsts/core/timer.dart';
import 'package:bsts/db/database.dart';
import 'package:bsts/managers/checkpoints_manager/checkpoints_manager.dart';
import 'package:bsts/packages/se_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class Setup implements IDisposable {
  Setup({this.databaseName = 'bsts.sqlite'});

  IDatabase database;
  String databasePath;
  String databaseName;

  ICheckpointsManager checkpointsManager;

  ITimer timer;
  Directory appDir;

  Future<void> init() async {
    await _initPaths();
    await _initDatabase();
    await _initServices();
    _initBlocInspections();
  }

  MultiProvider provide(Widget child) {
    return MultiProvider(
      providers: [
        Provider.value(value: checkpointsManager),
      ],
      child: child,
    );
  }

  Future _initPaths() async {
    appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);
    databasePath = path.join(appDir.path, databaseName);
  }

  Future<void> _initDatabase() async {
    final BstsDatabase db = BstsDatabase(databasePath);
    await db.init();
    database = db;
  }

  Future<void> _initServices() async {
    timer = Timer();
    checkpointsManager = CheckpointsManager(database: database);
    await checkpointsManager.init();
  }

  void _initBlocInspections() {
    BlocInspector.inspectTypes.addAll([]);
  }

  void dispose() {
    database.dispose();
  }
}
