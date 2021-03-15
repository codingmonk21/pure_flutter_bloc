library pure_flutter_bloc;

import 'package:flutter/material.dart';

import 'bloc_provider_core.dart';

/// {@template multi_bloc_listener}
/// Used to merge multiple [BlocListener] widgets into a single widget.
///
/// [MultiBlocListener] improves the readability and eliminates the need
/// to nest multiple [BlocListener]s.
///
/// By using [MultiBlocListener] the code changes from:
///
/// ```dart
/// BlocListener<BlocA, BlocAState>(
///   listener: (context, previous, current) {},
///   child: BlocListener<BlocB, BlocBState>(
///     listener: (context, previous, current) {},
///     child: BlocListener<BlocC, BlocCState>(
///       listener: (context, previous, current) {},
///       child: AnyWidget(),
///     ),
///   ),
/// )
/// ```
///
/// to:
///
/// ```dart
/// MultiBlocListener(
///   listeners: [
///     (child) => BlocListener<BlocA, BlocAState>(
///       listener: (context, previous, current) {},
///       child: child,
///     ),
///     (child) => BlocListener<BlocB, BlocBState>(
///       listener: (context, previous, current) {},
///       child: child,
///     ),
///     (child) => BlocListener<BlocC, BlocCState>(
///       listener: (context, previous, current) {},
///       child: child,
///     ),
///   ],
///   child: AnyWidget(),
/// )
/// ```
///
/// The only advantage of using [MultiBlocListener] is improved
/// readability as it eliminates the need to nest multiple [BlocListener]s.
///
/// {@endtemplate}
class MultiBlocListener extends MultiBlocProvider {
  MultiBlocListener({
    Key key,
    @required List<MultiBlocWidgetMixin Function(Widget child)> listeners,
    @required Widget child,
  })  : assert(listeners != null && listeners.length > 0),
        super(
        key: key,
        providers: listeners,
        child: child,
      );
}
