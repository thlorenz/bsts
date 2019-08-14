import 'package:bsts/bloc/checkpoints/checkpoints_bloc.dart';
import 'package:bsts/packages/se_bloc/factories.dart';
import 'package:bsts/pages/home_page/checkpoints_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<CheckpointsBloc>(
      builder: checkpointsBlocBuilder(context),
      dispose: (ctx, bloc) => bloc.dispose(),
      child: SafeArea(child: _HomePage()),
    );
  }
}

class _HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Better Safe Than Sorry'),
      ),
      body: blocBuilder<CheckpointsBloc, CheckpointsState, CheckpointsEvent>(
        context,
        _onCheckpointsChanged,
        CheckpointsView.providedState,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) => _onNavigationItemSelected(context, idx),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.redo),
            title: Text('redo'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('add'),
          ),
        ],
      ),
    );
  }

  void _onNavigationItemSelected(BuildContext context, int idx) {
    final bloc = Provider.of<CheckpointsBloc>(context);

    if (idx == 0) return bloc.reset();
    if (idx == 1) return bloc.add();
  }

  void _onCheckpointsChanged(
    BuildContext context,
    CheckpointsBloc bloc,
    CheckpointsEvent event,
  ) {}
}
