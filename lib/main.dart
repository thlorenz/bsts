import 'package:bsts/core/log.dart';
import 'package:bsts/pages/router.dart';
import 'package:bsts/setup.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  Log.activateConsole();
  Log.rootLevel = Level.FINEST;

  final setup = Setup();
  await setup.init();

  runApp(BstsApp(setup: setup));
}

class BstsApp extends StatelessWidget {
  const BstsApp({@required this.setup}) : super();
  final Setup setup;
  @override
  Widget build(BuildContext context) {
    final router = Router();
    final theme = ThemeData.dark();
    final app = MaterialApp(
      title: 'Bsts',
      theme: theme,
      onGenerateRoute: router.generateRoute,
      initialRoute: Routes.HOME,
    );

    return setup.provide(app);
  }
}
