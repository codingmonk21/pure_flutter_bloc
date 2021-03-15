import 'package:flutter/foundation.dart';
import 'package:pure_flutter_bloc/bloc_equatable.dart';

class DetailScreenState extends BlocEquatable {
  final int counterVal;
  final bool showLoader;

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
  List<Map<String, Object>> get propsMap => [
    {'counterVal': counterVal},
    {'showLoader': showLoader},
  ];

  @override
  bool get stringify => true;
}