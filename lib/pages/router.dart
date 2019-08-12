import 'package:bsts/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String HOME = '/';
  static const String CHECKPOINT_ADD = '/checkpoint.add';
}

class Router {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.HOME:
        return MaterialPageRoute<void>(
          builder: (_) => HomePage(),
          settings: settings,
        );
      case Routes.CHECKPOINT_ADD:
        // TODO:
        return null;
      default:
        return MaterialPageRoute<Scaffold>(
            builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}'))));
    }
  }
}
