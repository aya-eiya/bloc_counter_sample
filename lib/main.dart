import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

enum CounterEvent { decrement, reset }

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(10);

  void startCountDown() {
    Timer.periodic(Duration(seconds: 1), (_) {
      if (state == 0) {
        this.add(CounterEvent.reset);
      } else {
        this.add(CounterEvent.decrement);
      }
    });
  }

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    switch (event) {
      case CounterEvent.decrement:
        yield state - 1;
        break;
      case CounterEvent.reset:
        yield 10;
        break;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blob Timer Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: BlocProvider(
          create: (_) => CounterBloc()..startCountDown(), child: MyHomePage()),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Blob Timer Sample'),
            bottom: TabBar(tabs: const <Widget>[Text('Red'), Text('Blue')]),
          ),
          body: const TabBarView(children: <Widget>[
            Red(),
            Blue(),
          ]),
        ));
  }
}

class Red extends StatelessWidget {
  const Red({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Container(
        color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This is "Red" Page',
            ),
            BlocBuilder<CounterBloc, int>(
                builder: (context, state) => Text(
                    state == 0 ? 'Bang!!!!' : '$state',
                    style: Theme.of(context).textTheme.headline2)),
          ],
        ),
      );
}

class Blue extends StatelessWidget {
  const Blue({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This is "Blue" Page',
            ),
            BlocBuilder<CounterBloc, int>(
                builder: (context, state) => Text(
                    state == 0 ? 'Boon!!!!' : '$state',
                    style: Theme.of(context).textTheme.headline2)),
          ],
        ),
      );
}
