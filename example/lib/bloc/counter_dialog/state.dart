import 'package:flutter/foundation.dart';
import 'package:pure_flutter_bloc/bloc_equatable.dart';

class CounterDialogState extends BlocEquatable {
  final int counterVal;

  CounterDialogState({@required this.counterVal});

  CounterDialogState copyWith({
    int counterVal,
  }) {
    if ((counterVal == null || identical(counterVal, this.counterVal))) {
      return this;
    }

    return new CounterDialogState(
      counterVal: counterVal ?? this.counterVal,
    );
  }

  @override
  List<Map<String, Object>> get propsMap => [
    {'counterVal': counterVal},
  ];

  @override
  bool get stringify => true;
}