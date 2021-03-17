import 'package:pure_flutter_bloc/bloc.dart';

import 'change.dart';
import 'events.dart';
import 'state.dart';

class DetailScreenBloc extends Bloc<DetailScreenState, DetailScreenEvent> {
  @override
  DetailScreenState initState() {
    return DetailScreenState(
      counterVal: 0,
      showLoader: false,
    );
  }

  @override
  Stream<Change<DetailScreenState>> mapEventToChange(
      DetailScreenEvent event) async* {
    if (event is IncrementDetailScreenCounterEvent) {
      yield* Stream.value(1).map(
        (value) => IncrementScreenCounterChange(
          counterVal: value,
          showLoader: false,
        ),
      );
    }
  }
}
