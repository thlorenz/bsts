import 'package:bsts/bloc/checkpoints/checkpoints_bloc.dart';
import 'package:bsts/managers/checkpoints_manager/checkpoints_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

ValueBuilder<CheckpointsBloc> checkpointsBlocBuilder(
  BuildContext context,
) {
  final checkpointsManager = Provider.of<ICheckpointsManager>(context);
  return (ctx) => CheckpointsBloc(checkpointsManager: checkpointsManager);
}
