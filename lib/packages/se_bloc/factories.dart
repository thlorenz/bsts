import 'package:bsts/packages/se_bloc/bloc.dart';
import 'package:bsts/packages/se_bloc/event_listener.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

typedef SupplyWidgetState<TState> = Widget Function(TState state);
typedef StateToView<TState> = Widget Function(
    BuildContext context, TState state);

void ignoreEvent<TBloc, TEvent>(BuildContext _, TBloc b, TEvent e) {}

Widget streamBuilder<TState>(
  IStateStream<TState> stateStream,
  SupplyWidgetState<TState> widgetSuppliedState,
  TState stateOverride,
) {
  final streamValue = stateOverride != null
      ? BehaviorSubject<TState>().startWith(stateOverride)
      : stateStream.state$;

  return StreamProvider.value(
    value: streamValue,
    initialData: stateStream.currentState,
    child: Consumer<TState>(
        builder: (ctx, state, _) => widgetSuppliedState(state)),
  );
}

Widget blocBuilder<TBloc extends IBloc<TState, TEvent>, TState, TEvent>(
  BuildContext context,
  void Function(BuildContext, TBloc, TEvent) onEvent,
  SupplyWidgetState<TState> widgetSuppliedState, {
  TState stateOverride,
}) {
  final bloc = Provider.of<TBloc>(context);
  final statefulWidget =
      streamBuilder(bloc, widgetSuppliedState, stateOverride);
  return EventListener<TEvent>(
    eventStreamer: bloc,
    listener: (ctx, event) => onEvent(ctx, bloc, event),
    child: statefulWidget,
  );
}

Widget blocProvider<TBloc extends IBloc<TState, TEvent>, TState, TEvent>(
  BuildContext context,
  ValueBuilder<TBloc> builder,
  void Function(BuildContext, TBloc, TEvent) onEvent,
  StateToView<TState> stateToView, {
  Key key,
  TState stateOverride,
}) {
  return Provider<TBloc>(
    key: key,
    builder: builder,
    dispose: (_, bloc) => bloc.dispose(),
    child: _BlocProvidedWidget(
      onEvent,
      stateToView,
      stateOverride: stateOverride,
    ),
  );
}

class _BlocProvidedWidget<TBloc extends IBloc<TState, TEvent>, TState, TEvent>
    extends StatelessWidget {
  const _BlocProvidedWidget(
    this.onEvent,
    this.stateToView, {
    this.stateOverride,
  });

  final void Function(BuildContext, TBloc, TEvent) onEvent;
  final StateToView<TState> stateToView;
  final TState stateOverride;

  @override
  Widget build(BuildContext context) {
    return blocBuilder(
      context,
      onEvent,
      (TState state) => stateToView(context, state),
      stateOverride: stateOverride,
    );
  }
}
