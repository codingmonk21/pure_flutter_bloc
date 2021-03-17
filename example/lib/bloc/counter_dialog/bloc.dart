import 'package:pure_flutter_bloc/bloc.dart';

import 'change.dart';
import 'events.dart';
import 'state.dart';

class CounterDialogBloc extends Bloc<CounterDialogState, CounterDialogEvent> {
  @override
  CounterDialogState initState() {
    return CounterDialogState(counterVal: 0);
  }

  @override
  Stream<Change<CounterDialogState>> mapEventToChange(
      CounterDialogEvent event) async* {
    if (event is IncrementDialogCounterEvent) {
      yield DialogCounterValChange(
        counterVal: 10,
        isIncrement: true,
      );
    }

    if (event is DecrementDialogCounterEvent) {
      yield DialogCounterValChange(
        counterVal: 10,
        isIncrement: false,
      );
    }
  }
}
