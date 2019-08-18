import 'package:bsts/bloc/checkpoints/checkpoints_bloc.dart';
import 'package:bsts/packages/se_bloc/factories.dart';
import 'package:bsts/pages/home_page/checkpoints_view.dart';
import 'package:bsts/pages/router.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<CheckpointsBloc>(
      builder: checkpointsBlocBuilder(context),
      dispose: (ctx, bloc) => bloc.dispose(),
      child: SafeArea(
          child:
              blocProvider<CheckpointsBloc, CheckpointsState, CheckpointsEvent>(
        context,
        checkpointsBlocBuilder(context),
        _onCheckpointsChanged,
        _HomePage.stateToView,
      )),
    );
  }

  void _onCheckpointsChanged(
    BuildContext context,
    CheckpointsBloc bloc,
    CheckpointsEvent event,
  ) {}
}

class _HomePage extends StatelessWidget {
  const _HomePage({@required this.state});
  final CheckpointsState state;

  static Widget stateToView(
      BuildContext context, CheckpointsState checkpointsState) {
    assert(checkpointsState != null);
    return _HomePage(state: checkpointsState);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<CheckpointsBloc>(context);
    final filterItem = state.filteringUnverified
        ? BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('all'),
          )
        : BottomNavigationBarItem(
            icon: Icon(Icons.filter_list),
            title: Text('filter'),
          );
    final toggleEditItem = BottomNavigationBarItem(
      icon: Icon(Icons.edit),
      title: Text('edit'),
    );
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Better Safe Than Sorry'),
        ),
        body: CheckpointsView(state: state),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (idx) => _onNavigationItemSelected(context, idx),
          items: [
            filterItem,
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              title: Text('add'),
            ),
            toggleEditItem,
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.question),
              title: Text('Help'),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: bloc.reset,
          child: Icon(Icons.redo),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  void _onNavigationItemSelected(BuildContext context, int idx) {
    final bloc = Provider.of<CheckpointsBloc>(context);

    if (idx == 0) return bloc.toggleUnverified();
    if (idx == 1) {
      Navigator.of(context).pushNamed(Routes.CATEGORY_SELECT);
      return;
    }
    if (idx == 2) {
      Navigator.of(context).pushNamed(Routes.CHECKPOINTS_EDIT);
      return;
    }
    if (idx == 3) print('TODO: help');
  }
}
