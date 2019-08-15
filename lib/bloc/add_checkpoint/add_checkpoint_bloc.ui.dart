import 'package:bsts/bloc/add_checkpoint/add_checkpoint_bloc.dart';
import 'package:bsts/managers/checkpoints_manager/checkpoints_manager.dart';
import 'package:bsts/models/checkpoint.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

ValueBuilder<AddCheckpointBloc> addCheckpointBlocBuilder(
  String category,
  List<Checkpoint> checkpoints,
  BuildContext context,
) {
  final checkpointsManager = Provider.of<ICheckpointsManager>(context);
  return (ctx) => AddCheckpointBloc(
        checkpointsManager: checkpointsManager,
        category: category,
        checkpoints: checkpoints,
      );
}
