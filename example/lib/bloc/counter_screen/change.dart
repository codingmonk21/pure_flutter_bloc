import 'package:flutter/foundation.dart';
import 'package:pure_flutter_bloc/bloc.dart';

import 'state.dart';

class IncrementScreenCounterChange extends Change<CounterScreenState> {
  final int counterVal;
  final bool showLoader;

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'counterVal': this.counterVal,
      'showLoader': this.showLoader,
    } as Map<String, dynamic>;
  }

  IncrementScreenCounterChange({
    @required this.counterVal,
    @required this.showLoader,
  });

  @override
  CounterScreenState apply(CounterScreenState oldState) {
    return oldState.copyWith(
      counterVal: oldState.counterVal + counterVal,
      showLoader: showLoader,
    );
  }

  @override
  Map<String, Object> get propsMap => toMap();
}

class ShowDialogChange extends Change<CounterScreenState> {
  final bool shouldShowDialog;

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'shouldShowDialog': this.shouldShowDialog,
    } as Map<String, dynamic>;
  }

  ShowDialogChange(this.shouldShowDialog);

  @override
  CounterScreenState apply(CounterScreenState oldState) {
    return oldState.copyWith(shouldShowDialog: shouldShowDialog);
  }

  @override
  Map<String, Object> get propsMap => toMap();
}

class DismissDialogChange extends Change<CounterScreenState> {
  final bool shouldShowDialog;
  final int dialogCounterVal;

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'shouldShowDialog': this.shouldShowDialog,
      'dialogCounterVal': this.dialogCounterVal,
    } as Map<String, dynamic>;
  }

  DismissDialogChange({
    @required this.shouldShowDialog,
    @required this.dialogCounterVal,
  });

  @override
  CounterScreenState apply(CounterScreenState oldState) {
    return oldState.copyWith(
      shouldShowDialog: shouldShowDialog,
      dialogCounterVal: oldState.dialogCounterVal + dialogCounterVal,
    );
  }

  @override
  Map<String, Object> get propsMap => toMap();
}
