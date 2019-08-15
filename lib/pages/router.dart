import 'package:bsts/bloc/add_checkpoint/checkpoints.dart';
import 'package:bsts/pages/add_checkpoint_page/add_checkpoint_page.dart';
import 'package:bsts/pages/home_page/home_page.dart';
import 'package:bsts/pages/select_category_page/select_category_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String HOME = '/';
  static const String CATEGORY_SELECT = '/category.select';
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
      case Routes.CATEGORY_SELECT:
        return MaterialPageRoute<void>(
          builder: (_) => SelectCategoryPage(),
          settings: settings,
        );
      case Routes.CHECKPOINT_ADD:
        final category = settings.arguments as Category;
        return MaterialPageRoute<void>(
          builder: (_) => AddCheckpointPage(
            category: category.label,
            checkpoints: category.checkpoints,
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute<Scaffold>(
            builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}'))));
    }
  }
}
