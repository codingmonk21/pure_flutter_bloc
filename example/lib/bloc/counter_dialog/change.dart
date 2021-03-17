import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:pure_flutter_bloc/bloc.dart';

import 'state.dart';

class DialogCounterValChange extends Change<CounterDialogState> {
  final int counterVal;
  final bool isIncrement;

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'counterVal': this.counterVal,
      'isIncrement': this.isIncrement,
    } as Map<String, dynamic>;
  }

  DialogCounterValChange({
    @required this.counterVal,
    @required this.isIncrement,
  });

  @override
  CounterDialogState apply(CounterDialogState oldState) {
    return oldState.copyWith(
      counterVal: isIncrement
          ? (oldState.counterVal + counterVal)
          : (oldState.counterVal - counterVal),
    );
  }

  @override
  Map<String, Object> get propsMap => toMap();
}
