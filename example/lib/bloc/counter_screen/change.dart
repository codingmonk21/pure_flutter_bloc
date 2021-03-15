import 'package:flutter/foundation.dart';
import 'package:pure_flutter_bloc/bloc.dart';
import 'state.dart';

class IncrementScreenCounterChange extends Change<CounterScreenState> {
  final int counterVal;
  final bool showLoader;

  IncrementScreenCounterChange({
    @required this.counterVal,
    @required this.showLoader,
  });

  @override
  CounterScreenState apply(CounterScreenState oldState) {
    return oldState.copyWith(counterVal: oldState.counterVal + counterVal,
    showLoader: showLoader,);
  }

  @override
  List<Map<String, Object>> get propsMap => [
    {'counterVal': counterVal},
    {'showLoader': showLoader},
  ];
}

class ShowDialogChange extends Change<CounterScreenState> {
  final bool shouldShowDialog;

  ShowDialogChange(this.shouldShowDialog);

  @override
  CounterScreenState apply(CounterScreenState oldState) {
    return oldState.copyWith(shouldShowDialog: shouldShowDialog);
  }

  @override
  List<Map<String, Object>> get propsMap => [
    {'shouldShowDialog': shouldShowDialog},
  ];
}

class DismissDialogChange extends Change<CounterScreenState> {
  final bool shouldShowDialog;
  final int dialogCounterVal;

  DismissDialogChange({@required this.shouldShowDialog, @required this.dialogCounterVal});

  @override
  CounterScreenState apply(CounterScreenState oldState) {
    return oldState.copyWith(shouldShowDialog: shouldShowDialog, dialogCounterVal: oldState.dialogCounterVal + dialogCounterVal,);
  }

  @override
  List<Map<String, Object>> get propsMap => [
    {'shouldShowDialog': shouldShowDialog},
    {'dialogCounterVal': dialogCounterVal},
  ];
}