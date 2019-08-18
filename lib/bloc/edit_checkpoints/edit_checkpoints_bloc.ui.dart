import 'package:bsts/bloc/edit_checkpoints/edit_checkpoints_bloc.dart';
import 'package:bsts/managers/checkpoints_manager/checkpoints_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

ValueBuilder<EditCheckpointsBloc> editCheckpointsBlocBuilder(
    BuildContext context) {
  final checkpointsManager = Provider.of<ICheckpointsManager>(context);
  return (ctx) => EditCheckpointsBloc(
        checkpointsManager: checkpointsManager,
      );
}
