import 'package:bsts/bloc/edit_checkpoints/edit_checkpoints_bloc.dart';
import 'package:bsts/bloc/edit_checkpoints/edit_checkpoints_bloc.ui.dart';
import 'package:bsts/packages/se_bloc/factories.dart';
import 'package:bsts/pages/edit_checkpoints/edit_checkpoints_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditCheckpointsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return blocProvider<EditCheckpointsBloc, EditCheckpointsState,
        EditCheckpointsEvent>(
      context,
      editCheckpointsBlocBuilder(context),
      _onEditCheckpointsEvent,
      _EditCheckpointsPage.stateToView,
    );
  }

  void _onEditCheckpointsEvent(BuildContext context, EditCheckpointsBloc bloc,
      EditCheckpointsEvent event) {}
}

class _EditCheckpointsPage extends StatelessWidget {
  const _EditCheckpointsPage({@required this.state});
  final EditCheckpointsState state;

  static Widget stateToView(BuildContext context, EditCheckpointsState state) {
    return _EditCheckpointsPage(state: state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Checkpoints'),
      ),
      body: EditCheckpointsView(state: state),
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
    );
  }

  void _onNavigationItemSelected(BuildContext context, int idx) {
    if (idx == 0) Navigator.of(context).pop();
    if (idx == 1) print('TODO: help');
  }
}
