library pure_flutter_bloc;

import 'dart:async';

import 'package:flutter/material.dart';

import 'bloc.dart';

mixin MultiBlocWidgetMixin on Widget {}

/// {@template bloc_provider}
/// [BlocProvider] is a widget that acts as a dependency injector
/// in the widget tree to inject [Bloc] to one or more widgets in
/// the subtree.
///
/// It takes a [create] function which is responsible for
/// creating the [Bloc] and a [child] which will have access to the [Bloc]
/// created via `context.read<BlocA>()`.
///
/// The [create] function is called only once when the [BlocProvider] is
/// added to the widget tree which makes [Bloc] a singleton instance.
/// The same instance is provided to every widget in the subtree when
/// requested via `context.read<BlocA>()`.
///
/// Usage:
///
/// ```dart
/// BlocProvider(
///   create: () => BlocA(),
///   child: AnyWidget(),
/// );
/// ```
///
/// [BlocProvider] automatically disposes the [Bloc] when the [BlocProvider]
/// is removed from the widget tree. By default, [create] is called only when
/// one of the widget in the subtree tries to access the [Bloc] using
/// `context.read<BlocA>()`.
/// To override this behavior, set [lazy] to `false`.
///
/// ```dart
/// BlocProvider(
///   lazy: false,
///   create: () => BlocA(),
///   child: AnyWidget(),
/// );
/// ```
///
/// {@endtemplate}
class BlocProvider<T extends Bloc<Object, Object>> extends StatefulWidget
    with MultiBlocWidgetMixin {
  final T Function() create;

  /// Widget that will be rendered as a child widget of [BlocProvider]
  /// and has access to the [Bloc]
  final Widget child;

  /// Flag to indicate if the [Bloc] should be created lazily.
  /// Defaults to `true`.
  final bool lazy;

  BlocProvider({
    Key key,
    @required T Function() create,
    @required Widget child,
    bool lazy = true,
  }) : this._(
    key: key,
    create: create,
    child: child,
    lazy: lazy,
  );

  /// `BlocProvider.value` is used to provide an existing instance of
  /// [Bloc] to a new subtree which cannot access the [Bloc] via
  /// `context.read<BlocA>()`.
  ///
  /// Example: When navigating to new screen as shown below,
  ///
  /// ```dart
  /// Navigator.of(context).push(
  ///  MaterialPageRoute(builder: (ctx) {
  ///   return BlocProvider.value(
  ///       value: context.read<BlocB>(),
  ///       child: NewScreen(),
  ///     );
  ///   }),
  /// );
  /// ```
  ///
  /// [value] takes an existing instance of the [Bloc].
  /// An existing instance of the [Bloc] can be provided
  /// using `context.read<BlocA>()` which tries to access
  /// the [Bloc] that is exposed above in the widget tree.
  ///
  /// Never create a new instance of [Bloc] in the [value] field as
  /// `BlocProvider.value` doesn't have the ability to dispose the newly
  /// created [Bloc] when it gets itself removed from the widget tree.
  ///
  /// Usage:
  ///
  /// ```dart
  /// BlocProvider.value(
  ///   value: context.read<BlocA>(),
  ///   child: AnyWidget(),
  /// );
  /// ```
  ///
  BlocProvider.value({
    Key key,
    @required T value,
    @required Widget child,
  }) : this._(
    key: key,
    create: () => value,
    child: child,
  );

  BlocProvider._({
    Key key,
    this.create,
    this.child,
    this.lazy,
  })  : assert(create != null),
        assert(child != null),
        super(key: key);

  @override
  _BlocProviderState createState() {
    return _BlocProviderState<T>();
  }
}

class _Dummy {}

class _BlocProviderState<T extends Bloc<Object, Object>>
    extends State<BlocProvider<T>> {
  T _bloc;
  Object _val;
  bool _isInit = true;
  bool _isListening = false;
  StreamSubscription<Object> _bscn;

  @override
  void dispose() {
    _bloc?.dispose();
    _bscn?.cancel();
    super.dispose();
  }

  T _createBloc() {
    _bloc = _bloc ?? widget.create();
    if (!_isListening) {
      _isListening = true;
      _bscn = _bloc.listen((val) {
        if (_val != val) {
          setState(() {
            _val = val;
          });
        }
      });
    }
    return _bloc;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isInit = false;
      if (widget.lazy != null && !widget.lazy) {
        _createBloc();
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _BlocInheritedProvider<T>(
      val: _val,
      bloc: _createBloc,
      child: widget.child,
    );
  }
}

class _BlocInheritedProvider<T extends Bloc<Object, Object>>
    extends InheritedWidget {
  final Object val;
  final Widget child;
  final T Function() bloc;

  _BlocInheritedProvider({
    @required this.val,
    @required this.child,
    @required this.bloc,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    final old = oldWidget as _BlocInheritedProvider<T>;
    return old.val != this.val;
  }

  @override
  InheritedElement createElement() {
    return _BlocInheritedProviderElement<T>(this);
  }
}

class _BlocInheritedProviderElement<T extends Bloc<Object, Object>>
    extends InheritedElement {
  _BlocInheritedProviderElement(InheritedWidget widget) : super(widget);

  @override
  void updateDependencies(Element dependent, Object aspect) {
    if (aspect is _Dummy) {
    } else {
      super.updateDependencies(dependent, aspect);
    }
  }
}

/// {@template multi_bloc_provider}
/// Used to merge multiple [BlocProvider] widgets into a single widget.
///
/// [MultiBlocProvider] improves the readability and eliminates the need
/// to nest multiple [BlocProvider]s.
///
/// By using [MultiBlocProvider] the code changes from:
///
/// ```dart
/// BlocProvider<BlocA>(
///   create: () => BlocA(),
///   child: BlocProvider<BlocB>(
///     create: () => BlocB(),
///     child: BlocProvider<BlocC>(
///       create: () => BlocC(),
///       child: AnyWidget(),
///     )
///   )
/// )
/// ```
///
/// to:
///
/// ```dart
/// MultiBlocProvider(
///   providers: [
///     (child) => BlocProvider<BlocA>(
///       create: () => BlocA(),
///       child: child,
///     ),
///     (child) => BlocProvider<BlocB>(
///       create: () => BlocB(),
///       child: child,
///     ),
///     (child) => BlocProvider<BlocC>(
///       create: () => BlocC(),
///       child: child,
///     ),
///   ],
///   child: AnyWidget(),
/// )
/// ```
///
/// The only advantage of using [MultiBlocProvider] is improved
/// readability as it eliminates the need to nest multiple [BlocProvider]s.
///
/// {@endtemplate}
class MultiBlocProvider extends StatefulWidget {
  /// List of [BlocProvider]s that will be merged to a single widget.
  final List<MultiBlocWidgetMixin Function(Widget child)> providers;

  /// Widget that will be rendered as a child widget of [MultiBlocProvider]
  /// which has access to all the [BlocProvider]s exposed by [providers].
  final Widget child;

  const MultiBlocProvider({
    Key key,
    @required this.providers,
    @required this.child,
  })  : assert(providers != null && providers.length > 0),
        super(key: key);

  @override
  _MultiBlocProviderState createState() => _MultiBlocProviderState();
}

class _MultiBlocProviderState extends State<MultiBlocProvider> {
  bool _isInit = true;
  MultiBlocWidgetMixin _rootWidget;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isInit = false;
      _rootWidget = widget.providers[widget.providers.length - 1](widget.child);
      if (widget.providers.length > 1) {
        for (int i = widget.providers.length - 2; i >= 0; i--) {
          _rootWidget = widget.providers[i](_rootWidget);
        }
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _rootWidget;
  }
}

extension BlocProviderExtension on BuildContext {
  /// Used to get a reference to an instance of [Bloc]
  /// which is exposed in the widget tree above `this`
  /// context via [BlocProvider].
  T read<T extends Bloc<Object, Object>>() {
    _assertContext<T>(this);
    final widget =
    dependOnInheritedWidgetOfExactType<_BlocInheritedProvider<T>>(
      aspect: _Dummy(),
    );
    return widget == null
        ? throw BlocProviderNotFoundException(this)
        : widget.bloc();
  }

  /// Used to get a reference to the instance of
  /// [Bloc]'s state [S] and also add `this` widget
  /// as a dependency to the [Bloc] so that whenever the
  /// [Bloc] emits a new state [S], `this` widget gets notified.
  S watch<T extends Bloc<S, Object>, S>() {
    _assertContext<T>(this);
    assert(
    this.widget is LayoutBuilder ||
        this.widget is SliverWithKeepAliveWidget ||
        debugDoingBuild,
    '''
          Tried to use `context.watch<$T>` outside of the `build` method.        
          Please consider using `context.read<$T> instead.
      ''',
    );

    final widget =
    dependOnInheritedWidgetOfExactType<_BlocInheritedProvider<T>>();

    return widget == null
        ? throw BlocProviderNotFoundException(this)
        : widget.bloc().state;
  }
}

void _assertContext<T>(final BuildContext context) {
  assert(
  context != null,
  '''
      Tried to call context.read/watch on a `context` that is null.
      This can happen when you're trying to use the context of a StatefulWidget 
      and that StatefulWidget is disposed.
    ''',
  );

  assert(
  T != dynamic,
  '''
      Tried to call BlocProvider.of<dynamic> which doesn't conform to 
      the implementation details of `BlocProvider` class.       
    ''',
  );
}

class BlocProviderNotFoundException<T> implements Exception {
  final BuildContext context;

  const BlocProviderNotFoundException(this.context);

  @override
  String toString() {
    return '''
      BlocProvider<$T> was not found in any of the ancestor
      widgets. This can happen when, 

          1) BlocProvider<$T> is not exposed as one of the 
             ancestor widget.

          2) The context on which the read/watch was called 
             couldn't reach the ancestor BlocProvider<$T>.

          3) The context on which the read/watch was called 
             is above the BlocProvider<$T>.      
    ''';
  }
}
