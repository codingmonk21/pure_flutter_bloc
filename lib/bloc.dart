library pure_flutter_bloc;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_equatable.dart';

/// {@template bloc}
/// [Bloc] exposes only a single state of type [S]
/// throughout its lifetime. This state eventually
/// gets mutated by `Stream<Change<S>>` whenever
/// a new event [E] is added to the [Bloc].
/// {@endtemplate}
abstract class Bloc<S, E> {
  static const bool enableDebugLog = false;

  PublishSubject<_StateMachine<S, E>> _sms;
  BehaviorSubject<StateWrapper<S>> _sws;

  CompositeSubscription _cs;
  StreamSubscription<StateWrapper<S>> _smsn;

  S state;

  Bloc() {
    _init();
    _observe();
  }

  BlocObserver get observer => BlocObserver();

  void _init() {
    _cs = CompositeSubscription();
    _sms = PublishSubject<_StateMachine<S, E>>();
    _sws = BehaviorSubject<StateWrapper<S>>();
  }

  void _observe() {
    assert(initState() != null);
    state = initState();
    _smsn = _sms.stream.scan<_StateMachine<S, E>>(
          (_StateMachine previous, _StateMachine emitted, _) {
        final current = emitted.change.apply(
          previous.current == null ? previous.previous : previous.current,
        );
        observer.onTransition(Transition<S, E>(
          previous:
          previous.current == null ? previous.previous : previous.current,
          current: current,
          event: emitted.event,
        ));
        return _StateMachine(
          current: current,
          previous:
          previous.current == null ? previous.previous : previous.current,
          change: emitted.change,
          event: emitted.event,
        );
      },
      _StateMachine(
        current: null,
        previous: state,
        change: null,
        event: null,
      ),
    ).map((stateMachine) {
      return StateWrapper<S>(
        previous: stateMachine.previous,
        current: stateMachine.current,
        change: stateMachine.change,
      );
    }).listen(
          (StateWrapper<S> stateWrapper) {
        state = stateWrapper.current;
        _sws.sink.add(stateWrapper);
      },
      onError: (error) {
        observer.onError(error);
      },
      onDone: () {},
    );
    observer.onCreate(this.runtimeType);
  }

  /// Function that listens to `Stream` of [StateWrapper]
  StreamSubscription<StateWrapper<S>> listen(
      void Function(StateWrapper<S> s) onData, {
        Function onError,
        void Function() onDone,
        bool cancelOnError,
      }) {
    return _sws.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  void _dispatchChange(final Stream<Change<S>> cs, E event) {
    _dispose(
      cs.listen((change) {
        observer.onChange(event, change);
        _sms.sink.add(_StateMachine(
          change: change,
          event: event,
        ));
      }, onError: (error) {
        _sms.sink.addError(error);
      }),
    );
  }

  void _dispose<S>(final StreamSubscription<Change<S>> subscription) {
    _cs.add(subscription);
  }

  /// Concrete implementations of [Bloc] should
  /// implement this method and return the
  /// initial state [S]
  S initState();

  /// Function that add's an event [E] to [Bloc]
  /// which later gets mapped to `Stream<Change<S>>`
  /// by `mapEventToChange`.
  void dispatchEvent(final E event) {
    observer.onEvent(event);
    _dispatchChange(mapEventToChange(event), event);
  }

  /// Function that takes the incoming event [E]
  /// and translate it into `Stream<Change<S>>`
  Stream<Change<S>> mapEventToChange(E event);

  void dispose() async {
    _cs.clear();
    _smsn?.cancel();
    await _sms?.drain();
    _sms?.close();
    await _sws?.drain();
    _sws?.close();
    observer.onDispose(this.runtimeType);
  }
}

/// {@template change}
/// Concrete implementations of [Change]
/// should implement the [apply] method which returns
/// the updated instance of the state [S] for each
/// incoming event [E].
/// {@endtemplate}
abstract class Change<S> extends BlocEquatable {
  /// Function that takes the previous state instance [S]
  /// as input and returns the updated state instance [S].
  S apply(S previous);

  @override
  bool get stringify => true;
}

class _StateMachine<S, E> {
  final S previous;
  final S current;
  final E event;
  final Change<S> change;

  _StateMachine({this.previous, this.current, this.event, this.change});
}

/// Class that observes the lifecycle and events of all
/// concrete implementations of [Bloc] from a single place.
/// Logging [Bloc]'s lifecycle and its events is disabled by default.
/// Set [Bloc.enableDebugLog] to `true` to print logs to console.
class BlocObserver {
  /// Called when the [Bloc] instance is created
  /// by [create] in [BlocProvider]
  void onCreate(final Type type) {
    if (Bloc.enableDebugLog) print('$type created');
  }

  /// Called when [dispatchEvent] method is invoked to
  /// add an event [E] to the [Bloc]
  void onEvent(final Object event) {
    if (Bloc.enableDebugLog) print('${event?.runtimeType} dispatched');
  }

  /// Called when an event [E] is mapped to `Stream<Change<S>>`.
  /// [onChange] is called before state [S] has been updated.
  void onChange(final Object event, final Change change) {
    if (Bloc.enableDebugLog)
      print('onChange: ${event?.runtimeType} ==> ${change?.toString()}');
  }

  /// Called when the state [S] transitions to a new state [S]
  /// due to a [Change]
  void onTransition(final Transition transition) {
    if (Bloc.enableDebugLog) print(transition.toString());
  }

  /// Called when the `Stream<Change<S>>` throws an error
  void onError(final Object error) {
    if (Bloc.enableDebugLog) print('${error.toString()}');
  }

  /// Called when the [Bloc] is disposed
  void onDispose(final Type type) {
    if (Bloc.enableDebugLog) print('$type disposed');
  }
}

class StateWrapper<S> {
  final S previous;
  final S current;
  final Change<S> change;

  StateWrapper({
    @required this.previous,
    @required this.current,
    @required this.change,
  });
}

class Transition<S, E> {
  final S previous;
  final S current;
  final E event;

  Transition({
    @required this.previous,
    @required this.current,
    @required this.event,
  });

  @override
  String toString() {
    return 'from: ${previous.toString()} to: ${current.toString()} on: ${event.runtimeType}';
  }
}
