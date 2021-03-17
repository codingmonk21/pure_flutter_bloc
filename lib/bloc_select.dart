library pure_flutter_bloc;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'bloc.dart';
import 'bloc_extensions.dart';
import 'bloc_listener.dart';
import 'bloc_provider_core.dart';

/// {@template select}
/// [Select] rebuilds the UI in response to change in
/// `property` of a `state` in a given [Bloc].
///
/// It takes [select] which returns the `property` of a
/// given `state` to be observed to rebuild the UI.
///
/// It takes [build] which receives the updated `property`
/// of the `state` that can be used to build the UI.
///
/// [select] is passed with the initial value of the `property`
/// from the initial `state` of the [Bloc] when the [Select] is
/// initialised for the first time.
///
/// Usage:
///
/// ```dart
/// Select<BlocA, BlocAState, String>(
///   select: (state) {
///   // return the property of the BlocA
///   // state that should be observed
///   },
///   build: (context, property) {
///     // Use the updated property to
///     // rebuild the UI
///   }
/// )
/// ```
///
/// [build] is called whenever the `property` being observed changes.
///
/// {@endtemplate}
class Select<T extends Bloc<S, Object>, S, R> extends StatefulWidget {
  /// Function that returns the `property` of a `state` to be observed
  final R Function(S s) select;

  /// Function that returns a new widget when the `property` being
  /// observed changes
  final Widget Function(BuildContext context, R r) build;

  /// Flag when set to [true] logs the lifecycle information of [BlocWidget]
  /// widget to console.
  /// It is used for debugging purposes only and defaults to [false].
  final bool enableLifecycleLogs;

  Select({
    Key key,
    @required this.select,
    @required this.build,
    this.enableLifecycleLogs = false,
  })  : assert(select != null),
        super(key: key);

  @override
  _SelectState createState() {
    if (enableLifecycleLogs) createStateInvoked('Select<$T, $S>');
    return _SelectState<T, S, R>();
  }
}

class _SelectState<T extends Bloc<S, Object>, S, R>
    extends State<Select<T, S, R>> {
  R _value;

  @override
  Widget build(BuildContext context) {
    if (widget.enableLifecycleLogs) buildInvoked();
    return BlocListener<T, S>(
      listener: (ctx, previous, current) {
        bool areEqual = DeepCollectionEquality().equals(
          widget.select(previous),
          widget.select(current),
        );
        if (!areEqual) {
          setState(() {
            this._value = widget.select(current);
          });
        }
      },
      child: widget.build(
        context,
        _value ?? widget.select(context.read<T>().state),
      ),
    );
  }
}
