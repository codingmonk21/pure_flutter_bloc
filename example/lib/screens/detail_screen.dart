import 'package:flutter/material.dart';
import 'package:pure_flutter_bloc/pure_flutter_bloc.dart';

import '../bloc/detail_screen/bloc.dart';
import '../bloc/detail_screen/events.dart';
import '../bloc/detail_screen/state.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Screen'),
      ),
      body: BlocWidget<DetailScreenBloc, DetailScreenState>(
        build: (ctx, state) {
          return state != null ? bindData(state, ctx) : zeroStateWidget();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context
              .read<DetailScreenBloc>()
              .dispatchEvent(IncrementDetailScreenCounterEvent());
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget bindData(
    final DetailScreenState counterState,
    final BuildContext context,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          counterState.showLoader ? CircularProgressIndicator() : Container(),
          Text(
            'You have pushed the button this many times:',
          ),
          Text(
            '${counterState.counterVal}',
            style: Theme.of(context).textTheme.headline4,
          )
        ],
      ),
    );
  }

  Widget zeroStateWidget() {
    return Center(
      child: Text(
        "There's nothing much here to show....",
      ),
    );
  }
}
