# pure_flutter_bloc 1.0.0

A state management package that exposes simple to use widgets to quickly implement BLoc pattern in flutter apps.

This library is inspired by [flutter_bloc](https://pub.dev/packages/flutter_bloc) and [provider](https://pub.dev/packages/provider) package,
but built from ground up without any dependency on [flutter_bloc](https://pub.dev/packages/flutter_bloc) or [provider](https://pub.dev/packages/provider). 

The syntax of the widgets exposed almost aligns with the [flutter_bloc](https://pub.dev/packages/flutter_bloc) package. The fundamental difference between 
[flutter_bloc](https://pub.dev/packages/flutter_bloc) and 	**_pure_flutter_bloc_** lies in construction of the BLoc layer and the 
behaviour of the BLoc.

## BLoc Widgets

### BlocWidget

`BlocWidget` rebuilds the UI in response to `state` changes
 in a given `Bloc`. It takes `build` function which gets invoked
 for each `state` change in the `Bloc`.
 `build` is passed with the initial `state` of the `Bloc` when
 the BlocWidget is initialised for the first time.

 Usage:

```dart
BlocWidget<BlocA, BlocAState>(
  build: (context, state) {
  // return widget here based on BlocA's state
  }
)
```

### Select

`Select` widget rebuilds the UI in response to change in
`property` of a `state` in a given `Bloc`.
It takes `select` function which returns the `property` of a
given `state` to be observed to rebuild the UI.

It also takes a `build` function which receives the updated `property`
of the `state` that can be used to build the UI.

`select` is passed with the initial value of the `property`
from the initial `state` of the `Bloc` when the `Select` is
initialised for the first time.

Usage:

```dart
Select<BlocA, BlocAState, String>(
  select: (state) {
   // return the property of the BlocA
   // state that should be observed
  },
  build: (context, property) {
    // Use the updated property to
    // rebuild the UI
  }
)
```

`build` is called whenever the `property` being observed changes.

### BlocListener

`BlocListener` is used to cause side effects that should occur only once for each
`state` change such as, navigating to another screen, showing a `SnackBar`,
showing a `Dialog`, dispatch an event to `Bloc` etc...

The `listener` is called every time the `state` changes in the `Bloc`
and provides the access to `previous` and `current` `state` of the `Bloc` which can be used in conjunction to make a decision to cause a side effect.

Usage:

```dart
BlocListener<BlocA, BlocAState>(
  listener: (context, previous, current) {
    if( !previous.showDialog && current.showDialog ) {
    // cause side effect to show a dialog
    }
  },
  child: AnyWidget(),
)
```

### MultiBlocListener

Used to merge multiple `BlocListener` widgets into a single widget.

`MultiBlocListener` improves the readability and eliminates the need
to nest multiple `BlocListener`'s.

By using `MultiBlocListener` the code changes from:

```dart
BlocListener<BlocA, BlocAState>(
  listener: (context, previous, current) {},
  child: BlocListener<BlocB, BlocBState>(
    listener: (context, previous, current) {},
    child: BlocListener<BlocC, BlocCState>(
      listener: (context, previous, current) {},
      child: AnyWidget(),
    ),
  ),
)
```

to:

```dart
MultiBlocListener(
  listeners: [
    (child) => BlocListener<BlocA, BlocAState>(
      listener: (context, previous, current) {},
      child: child,
    ),
    (child) => BlocListener<BlocB, BlocBState>(
      listener: (context, previous, current) {},
      child: child,
    ),
    (child) => BlocListener<BlocC, BlocCState>(
      listener: (context, previous, current) {},
      child: child,
    ),
  ],
  child: AnyWidget(),
)
```

The only advantage of using `MultiBlocListener` is improved
readability as it eliminates the need to nest multiple `BlocListener`'s.

### BlocProvider

`BlocProvider` is a widget that acts as a dependency injector
in the widget tree to inject `Bloc` to one or more widgets in
the subtree.

It takes a `create` function which is responsible for
creating the `Bloc` and a `child` which will have access to the `Bloc`
created via `context.read<BlocA>()`.

The `create` function is called only once when the `BlocProvider` is
added to the widget tree which makes `Bloc` a singleton instance.
The same instance is provided to every widget in the subtree when
requested via `context.read<BlocA>()`.

Usage:

```dart
BlocProvider(
  create: () => BlocA(),
  child: AnyWidget(),
);
```

`BlocProvider` automatically disposes the `Bloc` when the `BlocProvider`
is removed from the widget tree. By default, `create` is called only when
one of the widget in the subtree tries to access the `Bloc` using
`context.read<BlocA>()`.
To override this behavior, set `lazy` to `false`.

```dart
BlocProvider(
  lazy: false,
  create: () => BlocA(),
  child: AnyWidget(),
);
```

`BlocProvider.value` constructor is used to provide an existing instance of
`Bloc` to a new subtree which cannot access the `Bloc` via
`context.read<BlocA>()`.

**Example**: When navigating to new screen as shown below,

```dart
Navigator.of(context).push(
 MaterialPageRoute(builder: (ctx) {
  return BlocProvider.value(
      value: context.read<BlocB>(),
      child: NewScreen(),
    );
  }),
);
```

`value` takes an existing instance of the `Bloc`.
An existing instance of the `Bloc` can be provided
using `context.read<BlocA>()` which tries to access
the `Bloc` that is exposed above in the widget tree.

Never create a new instance of `Bloc` in the `value` field as
`BlocProvider.value` doesn't have the ability to dispose the newly
created `Bloc` when it gets itself removed from the widget tree.

Usage:

```dart
BlocProvider.value(
  value: context.read<BlocA>(),
  child: AnyWidget(),
);
```

### MultiBlocProvider

Used to merge multiple `BlocProvider` widgets into a single widget.

`MultiBlocProvider` improves the readability and eliminates the need
to nest multiple `BlocProvider`s.

By using `MultiBlocProvider` the code changes from:

```dart
BlocProvider<BlocA>(
  create: () => BlocA(),
  child: BlocProvider<BlocB>(
    create: () => BlocB(),
    child: BlocProvider<BlocC>(
      create: () => BlocC(),
      child: AnyWidget(),
    )
  )
)
```

to:

```dart
MultiBlocProvider(
  providers: [
    (child) => BlocProvider<BlocA>(
      create: () => BlocA(),
      child: child,
    ),
    (child) => BlocProvider<BlocB>(
      create: () => BlocB(),
      child: child,
    ),
    (child) => BlocProvider<BlocC>(
      create: () => BlocC(),
      child: child,
    ),
  ],
  child: AnyWidget(),
)
```

The only advantage of using `MultiBlocProvider` is improved
readability as it eliminates the need to nest multiple `BlocProvider`'s.

## Example
[Counter App](https://github.com/codingmonk21/pure_flutter_bloc/tree/master/example)

## Maintainers
[Prajwal C](https://github.com/codingmonk21)