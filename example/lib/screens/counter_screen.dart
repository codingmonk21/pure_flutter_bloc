import 'package:flutter/material.dart';
import 'package:pure_flutter_bloc/bloc_extensions.dart';
import 'package:pure_flutter_bloc/pure_flutter_bloc.dart';

import '../bloc/counter_dialog/bloc.dart';
import '../bloc/counter_dialog/events.dart';
import '../bloc/counter_dialog/state.dart';
import '../bloc/counter_screen/bloc.dart';
import '../bloc/counter_screen/events.dart';
import '../bloc/counter_screen/state.dart';
import '../bloc/detail_screen/bloc.dart';
import '../bloc/detail_screen/state.dart';
import 'detail_screen.dart';

class CounterScreen extends StatefulWidget {
  final Function() rebuildApp;

  const CounterScreen({Key key, this.rebuildApp}) : super(key: key);

  @override
  _HomeScreenState createState() {
    createStateInvoked('HomeScreen');
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<CounterScreen> {
  @override
  Widget build(BuildContext context) {
    buildInvoked();
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter App'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) {
                  return DetailScreen();
                }),
              );
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          (child) {
            return BlocListener<CounterScreenBloc, CounterScreenState>(
              child: child,
              listener: (ctx, previous, current) {
                if (!previous.shouldShowDialog && current.shouldShowDialog) {
                  return showDialog<int>(
                    barrierDismissible: false,
                    builder: (dialogCtx) {
                      return getDialog(dialogCtx);
                    },
                    context: context,
                  )?.then((value) {
                    context
                        .read<CounterScreenBloc>()
                        .dispatchEvent(DismissDialogEvent(value));
                  });
                }
              },
            );
          },
          (child) {
            return BlocListener<DetailScreenBloc, DetailScreenState>(
              child: child,
              listener: (ctx, previous, current) {
                print('Detail Screen State Changed');
              },
            );
          },
        ],
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocWidget<CounterScreenBloc, CounterScreenState>(
                build: (ctx, state) {
                  return state != null
                      ? bindDataToWidget(state, ctx)
                      : zeroStateWidget();
                },
              ),
              space(),
              Select<CounterScreenBloc, CounterScreenState, int>(
                select: (state) {
                  return state.counterVal;
                },
                build: (ctx, val) {
                  return Column(
                    children: [
                      Text('Selected value:'),
                      counterTextWidget(val),
                    ],
                  );
                },
              ),
              space(),
              RaisedButton(
                child: Text('Rebuild App'),
                onPressed: () {
                  Future.delayed(
                      Duration(seconds: 3), () => widget.rebuildApp());
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context
              .read<CounterScreenBloc>()
              .dispatchEvent(IncrementScreenCounterEvent());
          context.read<CounterScreenBloc>().dispatchEvent(ShowDialogEvent());
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget bindDataToWidget(
    final CounterScreenState counterState,
    final BuildContext context,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          counterState.showLoader ? CircularProgressIndicator() : Container(),
          Text('You have pushed the button this many times:'),
          counterTextWidget(counterState.counterVal),
          space(),
          Text(
            'Last Dialog Counter Val:',
          ),
          counterTextWidget(counterState.dialogCounterVal),
        ],
      ),
    );
  }

  Widget space() {
    return SizedBox(
      height: 20,
    );
  }

  Widget counterTextWidget(final int value) {
    return Text(
      '$value',
      style: Theme.of(context).textTheme.headline4,
    );
  }

  Widget zeroStateWidget() {
    return Center(
      child: Text("There's nothing much here to show..."),
    );
  }

  Widget getDialog(final BuildContext dialogCtx) {
    return BlocProvider<CounterDialogBloc>(
      create: () => CounterDialogBloc(),
      child: BlocWidget<CounterDialogBloc, CounterDialogState>(
        build: (ctx, state) {
          return AlertDialog(
            title: Text("Counter Dialog"),
            content: getDialogContent(ctx, state),
          );
        },
      ),
    );
  }

  Widget getDialogContent(
      final BuildContext ctx, final CounterDialogState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Dialog Counter : ${(state == null) ? 0 : state.counterVal}'),
        space(),
        getDialogButtons(ctx, state)
      ],
    );
  }

  Widget getDialogButtons(
      final BuildContext context, final CounterDialogState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              onPressed: () {
                context
                    .read<CounterDialogBloc>()
                    .dispatchEvent(IncrementDialogCounterEvent());
              },
              child: Text(
                'Increment',
              ),
            ),
            RaisedButton(
              onPressed: () {
                context
                    .read<CounterDialogBloc>()
                    .dispatchEvent(DecrementDialogCounterEvent());
              },
              child: Text(
                'Decrement',
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          child: RaisedButton(
            child: Text('DISMISS'),
            onPressed: () {
              if (state != null) {
                Navigator.pop(context, state.counterVal);
              } else {
                Navigator.pop(context, 0);
              }
            },
          ),
        )
      ],
    );
  }
}
