library pure_flutter_bloc;

import 'package:flutter/material.dart';

extension StatelessWidgetLogs on StatelessWidget {
  void buildInvoked(final BuildContext context) {
    print('build invoked for ${context.widgetName}');
  }
}

extension StatefulWidgetLogs on StatefulWidget {
  void createStateInvoked(final String widgetName) {
    print('createStateInvoked invoked for $widgetName');
  }
}

extension StateLogs on State {
  void initStateInvoked() {
    print('initState invoked for ${context.widgetName}');
  }

  void buildInvoked() {
    print('build invoked for ${context.widgetName}');
  }

  void didChangeDependenciesInvoked() {
    print('didChangeDependencies invoked for ${context.widgetName}');
  }

  void didUpdateWidgetInvoked() {
    print('didUpdateWidget invoked for ${context.widgetName}');
  }

  void disposeInvoked() {
    print('dispose invoked for ${context.widgetName}');
  }
}

extension Context on BuildContext {
  String get widgetName => widget.runtimeType.toString();
}
