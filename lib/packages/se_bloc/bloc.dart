import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

typedef InspectItem<T> = void Function(T item);
Type _typeOf<T>() => T;

abstract class IStateStream<T> {
  T get currentState;
  Observable<T> get state$;
  void state(T state);
  void dispose();
}

abstract class IEventStream<T> {
  Observable<T> get event$;
  void event(T event);
  void dispose();
}

abstract class IBloc<TState, TEvent>
    implements IStateStream<TState>, IEventStream<TEvent> {}

abstract class StateStreamBase<T> implements IStateStream<T> {
  StateStreamBase(T initialState, this.inspect)
      : _state$ = initialState == null
            ? BehaviorSubject<T>()
            : BehaviorSubject<T>.seeded(initialState);

  final BehaviorSubject<T> _state$;

  Observable<T> get state$ => _inspected(_state$, inspect);

  T get currentState => _state$.value;

  final InspectItem<T> inspect;

  @protected
  bool disposed = false;

  void state(T state) {
    if (!disposed) {
      _state$.add(state);
    }
  }

  @mustCallSuper
  void dispose() {
    _state$.close();
    disposed = true;
  }
}

abstract class EventStreamBase<T> implements IEventStream<T> {
  EventStreamBase(this.inspect);

  final Subject<T> _event$ = PublishSubject<T>();
  Observable<T> get event$ => _inspected(_event$, inspect);

  final InspectItem<T> inspect;
  @protected
  bool disposed = false;

  void event(T event) {
    if (!disposed) {
      _event$.add(event);
    }
  }

  @mustCallSuper
  void dispose() {
    _event$.close();
    disposed = true;
  }
}

abstract class BlocBase<TState, TEvent> extends StateStreamBase<TState>
    implements IBloc<TState, TEvent> {
  BlocBase({
    this.inspectEvent,
    TState initialState,
    InspectItem<TState> inspectState,
  }) : super(initialState, inspectState);

  final InspectItem<TEvent> inspectEvent;

  final Subject<TEvent> _event$ = PublishSubject<TEvent>();
  Observable<TEvent> get event$ => _inspected(_event$, inspectEvent);

  void event(TEvent event) {
    assert(!disposed);
    _event$.add(event);
  }

  @mustCallSuper
  void dispose() {
    _event$.close();
    super.dispose();
  }
}

Observable<T> _inspected<T>(Observable<T> stream, InspectItem<T> inspect) {
  return inspect != null
      ? stream.doOnData(inspect)
      : BlocInspector.inspectTypes.contains(_typeOf<T>())
          ? stream.doOnData(BlocInspector.inspect)
          : stream;
}

class BlocInspector {
  static Set<Type> inspectTypes = <Type>{};
  static void inspect<T>(T x) => print(x);
}
