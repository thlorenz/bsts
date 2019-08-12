// ignore_for_file: prefer_mixin
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:bsts/packages/se_bloc/bloc.dart';

typedef EventWidgetListener<T> = void Function(BuildContext context, T event);
typedef EventListenerCondition<T> = bool Function(T previous, T current);

class EventListener<TEvent> extends EventListenerBase<TEvent>
    with SingleChildCloneableWidget {
  const EventListener({
    @required IEventStream<TEvent> eventStreamer,
    @required EventWidgetListener<TEvent> listener,
    EventListenerCondition<TEvent> condition,
    this.child,
    Key key,
  })  : assert(eventStreamer != null, 'eventStreamer cannot be null'),
        assert(listener != null, 'listener cannot be null'),
        super(
          key: key,
          eventStreamer: eventStreamer,
          listener: listener,
          condition: condition,
        );

  final Widget child;

  @override
  EventListener<TEvent> cloneWithChild(Widget child) {
    return EventListener<TEvent>(
      key: key,
      eventStreamer: eventStreamer,
      listener: listener,
      condition: condition,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) => child;
}

abstract class EventListenerBase<T> extends StatefulWidget {
  const EventListenerBase({
    @required this.eventStreamer,
    @required this.listener,
    @required this.condition,
    Key key,
  }) : super(key: key);

  final IEventStream<T> eventStreamer;
  final EventWidgetListener<T> listener;
  final EventListenerCondition<T> condition;

  State<EventListenerBase<T>> createState() => _EventListenerBaseState<T>();

  Widget build(BuildContext context);
}

class _EventListenerBaseState<T> extends State<EventListenerBase<T>> {
  StreamSubscription<T> _subscription;
  T _previousEvent;

  @override
  void initState() {
    super.initState();
    _previousEvent = null;
    _subscribe();
  }

  @override
  void didUpdateWidget(EventListenerBase<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.eventStreamer.event$ != widget.eventStreamer.event$) {
      if (_subscription != null) {
        _unsubscribe();
        _previousEvent = null;
      }
      _subscribe();
    }
  }

  @override
  Widget build(BuildContext context) => widget.build(context);

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (widget.eventStreamer.event$ != null) {
      _subscription = widget.eventStreamer.event$.listen((T event) {
        if (widget.condition?.call(_previousEvent, event) ?? true) {
          widget.listener(context, event);
        }
        _previousEvent = event;
      });
    }
  }

  void _unsubscribe() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
  }
}
