library pure_flutter_bloc;

import 'package:flutter/material.dart';

import 'bloc.dart';
import 'bloc_extensions.dart';
import 'bloc_listener.dart';
import 'bloc_provider_core.dart';

/// {@template bloc_widget}
/// [BlocWidget] rebuilds the UI in response to `state` changes
/// in a given [Bloc]. It takes [build] which gets invoked
/// for each `state` change in the [Bloc].
///
/// [build] is passed with the initial `state` of the [Bloc] when
/// the [BlocWidget] is initialised for the first time.
///
/// Usage:
///
/// ```dart
/// BlocWidget<BlocA, BlocAState>(
///   build: (context, state) {
///   // return widget here based on BlocA's state
///   }
/// )
/// ```
///
/// {@endtemplate}
class BlocWidget<T extends Bloc<S, Object>, S> extends StatefulWidget {
  /// Function that returns a new widget for each `state` change in the [Bloc]
  final Widget Function(BuildContext context, S state) build;

  /// Flag when set to [true] logs the lifecycle information of [BlocWidget]
  /// widget to console.
  /// It is used for debugging purposes only and defaults to [false].
  final bool enableLifecycleLogs;

  BlocWidget({
    Key key,
    @required this.build,
    this.enableLifecycleLogs = false,
  }) : super(key: key);

  @override
  _BlocWidgetState createState() {
    if (enableLifecycleLogs) createStateInvoked('BlocWidget<$T, $S>');
    return _BlocWidgetState<T, S>();
  }
}

class _BlocWidgetState<T extends Bloc<S, Object>, S>
    extends State<BlocWidget<T, S>> {
  S _state;

  @override
  Widget build(BuildContext context) {
    if (widget.enableLifecycleLogs) buildInvoked();
    return BlocListener<T, S>(
      listener: (ctx, previous, current) => setState(() => _state = current),
      child: widget.build(
        context,
        _state ?? context.read<T>().state,
      ),
    );
  }
}
