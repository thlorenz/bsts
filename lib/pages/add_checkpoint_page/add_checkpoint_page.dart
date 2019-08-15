import 'package:bsts/bloc/add_checkpoint/add_checkpoint_bloc.dart';
import 'package:bsts/core_ui/snackbar.dart';
import 'package:bsts/models/checkpoint.dart';
import 'package:bsts/packages/se_bloc/factories.dart';
import 'package:bsts/pages/add_checkpoint_page/add_checkpoint_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meta/meta.dart';

class AddCheckpointPage extends StatelessWidget {
  const AddCheckpointPage({
    @required this.category,
    @required this.checkpoints,
  });

  final String category;
  final List<Checkpoint> checkpoints;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Add $category Checkpoint'),
        ),
        body: _buildAddCheckpointView(context),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (idx) => _onNavigationItemSelected(context, idx),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.question,
              ),
              title: Text('Help'),
            ),
          ],
        ),
      ),
    );
  }

  void _onAddCheckpointEvent(
    BuildContext context,
    AddCheckpointBloc bloc,
    AddCheckpointEvent event,
  ) {
    switch (event.type) {
      case AddCheckpointEventType.adding:
        refreshSnackBar(
          context,
          'Added ${event.checkpointLabel} checkpoint',
          event.importance,
        );
        break;
    }
  }

  void _onNavigationItemSelected(BuildContext context, int idx) {
    if (idx == 0) Navigator.of(context)..pop()..pop();
    if (idx == 1) print('TODO: help');
  }

  Widget _buildAddCheckpointView(BuildContext context) =>
      blocProvider<AddCheckpointBloc, AddCheckpointState, AddCheckpointEvent>(
        context,
        addCheckpointBlocBuilder(category, checkpoints, context),
        _onAddCheckpointEvent,
        AddCheckpointView.stateToView,
      );
}
