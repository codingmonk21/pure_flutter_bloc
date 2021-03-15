import 'package:flutter/foundation.dart';
import 'package:pure_flutter_bloc/bloc.dart';
import 'state.dart';

class DialogCounterValChange extends Change<CounterDialogState> {
  final int counterVal;
  final bool isIncrement;

  DialogCounterValChange({@required this.counterVal, @required this.isIncrement,});

  @override
  CounterDialogState apply(CounterDialogState oldState) {
    return oldState.copyWith(counterVal: isIncrement ? (oldState.counterVal + counterVal) : (oldState.counterVal - counterVal));
  }

  @override
  List<Map<String, Object>> get propsMap => [
    {'counterVal': counterVal},
    {'isIncrement': isIncrement},
  ];
}