import 'package:flutter/foundation.dart';
import 'package:pure_flutter_bloc/bloc.dart';

import 'state.dart';

class IncrementScreenCounterChange extends Change<DetailScreenState> {
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
  DetailScreenState apply(DetailScreenState oldState) {
    return oldState.copyWith(
      counterVal: oldState.counterVal + counterVal,
      showLoader: showLoader,
    );
  }

  @override
  Map<String, Object> get propsMap => toMap();
}
