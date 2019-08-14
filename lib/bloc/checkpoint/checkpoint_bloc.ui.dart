import 'package:bsts/bloc/checkpoint/checkpoint_bloc.dart';
import 'package:bsts/core/timer.dart';
import 'package:bsts/managers/checkpoints_manager/checkpoints_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

ValueBuilder<CheckpointBloc> checkpointBlocBuilder(
  BuildContext context,
  String id,
) {
  final checkpointsManager = Provider.of<ICheckpointsManager>(context);
  final timer = Provider.of<ITimer>(context);
  return (ctx) => CheckpointBloc(
        id: id,
        checkpointsManager: checkpointsManager,
        timer: timer,
      );
}
