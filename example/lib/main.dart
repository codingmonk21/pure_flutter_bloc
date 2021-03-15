import 'package:flutter/material.dart';
import 'package:pure_flutter_bloc/bloc_extensions.dart';
import 'package:pure_flutter_bloc/bloc_provider_core.dart';
import './screens/counter_screen.dart';
import './bloc/counter_screen/bloc.dart';
import './bloc/detail_screen/bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() {
    createStateInvoked('MyApp');
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  void _rebuildApp() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initStateInvoked();
  }

  @override
  Widget build(BuildContext context) {
    buildInvoked();
    return MultiBlocProvider(
      providers: [
            (child) => BlocProvider<CounterScreenBloc>(
          create: () {
            return CounterScreenBloc();
          },
          child: child,
        ),
            (child) => BlocProvider<DetailScreenBloc>(
          create: () {
            return DetailScreenBloc();
          },
          child: child,
        ),
      ],
      child: MaterialApp(
        title: 'Bloc App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: CounterScreen(
          rebuildApp: _rebuildApp,
        ),
      ),
    );
  }
}
