import 'package:bsts/bloc/add_checkpoint/checkpoints.dart';
import 'package:flutter/material.dart';

class SelectCategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Select Checkpoint Category'),
        ),
        body: _SelectCategoryView(),
      ),
    );
  }
}

class _SelectCategoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: Checkpoints.categories.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (ctx, idx) => _SelectCategoryItem(
        category: Checkpoints.categories[idx],
      ),
    );
  }
}

class _SelectCategoryItem extends StatelessWidget {
  const _SelectCategoryItem({this.category});
  final Category category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderSide = BorderSide(width: 2, color: Colors.white24);
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(
          top: borderSide,
          right: borderSide,
          bottom: borderSide,
          left: borderSide,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: InkWell(
        onTap: null, // TODO: navigate
        child: GridTile(
          header: Text(
            category.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.primaryTextTheme.headline.color,
              fontSize: 24,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Icon(
                category.icon,
                color: category.color,
                size: 80,
              ),
            ),
          ),
        ),
      ),
    );
  }
}