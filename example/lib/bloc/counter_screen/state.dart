import 'package:flutter/foundation.dart';
import 'package:pure_flutter_bloc/bloc_equatable.dart';

class CounterScreenState extends BlocEquatable {
  final int counterVal;
  final bool showLoader;
  final bool shouldShowDialog;
  final int dialogCounterVal;

  CounterScreenState copyWith({
    int counterVal,
    bool showLoader,
    bool shouldShowDialog,
    int dialogCounterVal,
  }) {
    if ((counterVal == null || identical(counterVal, this.counterVal)) &&
        (showLoader == null || identical(showLoader, this.showLoader)) &&
        (shouldShowDialog == null ||
            identical(shouldShowDialog, this.shouldShowDialog)) &&
        (dialogCounterVal == null ||
            identical(dialogCounterVal, this.dialogCounterVal))) {
      return this;
    }

    return new CounterScreenState(
      counterVal: counterVal ?? this.counterVal,
      showLoader: showLoader ?? this.showLoader,
      shouldShowDialog: shouldShowDialog ?? this.shouldShowDialog,
      dialogCounterVal: dialogCounterVal ?? this.dialogCounterVal,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'counterVal': this.counterVal,
      'showLoader': this.showLoader,
      'shouldShowDialog': this.shouldShowDialog,
      'dialogCounterVal': this.dialogCounterVal,
    } as Map<String, dynamic>;
  }

  CounterScreenState({
    @required this.counterVal,
    @required this.showLoader,
    @required this.shouldShowDialog,
    @required this.dialogCounterVal,
  });

  @override
  Map<String, Object> get propsMap => toMap();

  @override
  bool get stringify => true;
}
