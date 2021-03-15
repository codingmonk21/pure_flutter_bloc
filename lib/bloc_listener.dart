library pure_flutter_bloc;

import 'dart:async';
import 'package:flutter/material.dart';
import 'bloc_provider_core.dart';
import 'bloc.dart';
import 'bloc_extensions.dart';

/// {@template bloc_listener}
/// [BlocListener] is used to cause side effects that should occur only once for each
/// `state` change such as, navigating to another screen, showing a `SnackBar`,
/// showing a `Dialog`, dispatch an event to [Bloc] etc...
///
/// The [listener] is called every time the `state` changes in the [Bloc]
/// and provides the access to [previous] and [current] `state` of the [Bloc]
/// which can be used in conjunction to make a decision to cause a side effect.
///
/// Usage:
///
/// ```dart
/// BlocListener<BlocA, BlocAState>(
///   listener: (context, previous, current) {
///     if( !previous.showDialog && current.showDialog ) {
///     // cause side effect to show a dialog
///     }
///   },
///   child: AnyWidget(),
/// )
/// ```
/// {@endtemplate}
class BlocListener<T extends Bloc<S, Object>, S> extends StatefulWidget
    with MultiBlocWidgetMixin {
  /// Widget that will be rendered as a child widget of [BlocListener].
  final Widget child;

  /// Listener that react to `state` changes from the [Bloc].
  final void Function(BuildContext context, S previous, S current) listener;

  /// Listener that listens to [Change]s applied to [Bloc] state.
  /// This listener is optional and can be used when there are nested [Bloc]
  /// dependencies
  final void Function(Change<S> change) changeListener;

  /// Flag when set to [true] logs the lifecycle information of [BlocListener]
  /// widget to console.
  /// It is used for debugging purposes only and defaults to [false].
  final bool enableLifecycleLogs;

  BlocListener({
    Key key,
    @required this.child,
    @required this.listener,
    this.changeListener,
    this.enableLifecycleLogs = false,
  })  : assert(listener != null),
        super(key: key);

  @override
  _BlocListenerState createState() {
    if (enableLifecycleLogs) createStateInvoked('BlocListener<$T, $S>');
    return _BlocListenerState<T, S>();
  }
}

class _BlocListenerState<T extends Bloc<S, Object>, S>
    extends State<BlocListener<T, S>> {
  bool _isInit;
  StreamSubscription<StateWrapper<S>> _ss;

  @override
  void initState() {
    if (widget.enableLifecycleLogs) initStateInvoked();
    _isInit = true;
    super.initState();
  }

  @override
  void dispose() {
    if (widget.enableLifecycleLogs) disposeInvoked();
    _ss?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (widget.enableLifecycleLogs) didChangeDependenciesInvoked();
    if (_isInit) {
      _isInit = false;
      _ss = context.read<T>().listen((StateWrapper<S> state) {
        widget.listener?.call(
          context,
          state.previous,
          state.current,
        );
        widget.changeListener?.call(state.change);
      });
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant BlocListener<T, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enableLifecycleLogs) didUpdateWidgetInvoked();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enableLifecycleLogs) buildInvoked();
    return widget.child;
  }
}
