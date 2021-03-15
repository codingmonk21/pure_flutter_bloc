abstract class CounterEvent {}

class IncrementScreenCounterEvent extends CounterEvent {}

class DecrementScreenCounterEvent extends CounterEvent {}

class ShowDialogEvent extends CounterEvent {}

class DismissDialogEvent extends CounterEvent {
  final int dialogCounterVal;

  DismissDialogEvent(this.dialogCounterVal);
}