import 'package:flutter/foundation.dart';
import 'package:pure_flutter_bloc/bloc_equatable.dart';

class DetailScreenState extends BlocEquatable {
  final int counterVal;
  final bool showLoader;

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'counterVal': this.counterVal,
      'showLoader': this.showLoader,
    } as Map<String, dynamic>;
  }

  DetailScreenState copyWith({
    int counterVal,
    bool showLoader,
  }) {
    if ((counterVal == null || identical(counterVal, this.counterVal)) &&
        (showLoader == null || identical(showLoader, this.showLoader))) {
      return this;
    }

    return new DetailScreenState(
      counterVal: counterVal ?? this.counterVal,
      showLoader: showLoader ?? this.showLoader,
    );
  }

  DetailScreenState({
    @required this.counterVal,
    @required this.showLoader,
  });

  @override
  Map<String, Object> get propsMap => toMap();

  @override
  bool get stringify => true;
}