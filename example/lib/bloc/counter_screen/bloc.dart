import 'package:pure_flutter_bloc/bloc.dart';
import 'state.dart';
import 'events.dart';
import 'change.dart';

class CounterScreenBloc extends Bloc<CounterScreenState, CounterEvent> {
  @override
  CounterScreenState initState() {
    return CounterScreenState(
      counterVal: 0,
      showLoader: false,
      dialogCounterVal: 0,
      shouldShowDialog: false,
    );
  }

  @override
  Stream<Change<CounterScreenState>> mapEventToChange(CounterEvent event) async* {
    if (event is IncrementScreenCounterEvent) {
      yield* Stream.value(1).map((value) => IncrementScreenCounterChange(
            counterVal: value,
            showLoader: false,
          ));
    }

    if (event is ShowDialogEvent) {
      yield* Stream.value(true).map(
        (value) => ShowDialogChange(value),
      );
    }

    if (event is DismissDialogEvent) {
      yield* Stream.value(false).map(
        (value) => DismissDialogChange(shouldShowDialog: false, dialogCounterVal: event.dialogCounterVal),
      );
    }
  }
}
