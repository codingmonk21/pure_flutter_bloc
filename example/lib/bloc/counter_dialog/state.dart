import 'package:flutter/foundation.dart';
import 'package:pure_flutter_bloc/bloc_equatable.dart';

class CounterDialogState extends BlocEquatable {
  final int counterVal;

  CounterDialogState({@required this.counterVal});

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'counterVal': this.counterVal,
    } as Map<String, dynamic>;
  }

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
  Map<String, Object> get propsMap => toMap();

  @override
  bool get stringify => true;
}