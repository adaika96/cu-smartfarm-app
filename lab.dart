import 'package:bloc/bloc.dart';
import 'dart:convert';
abstract class CounterEvent {}

class Increment extends CounterEvent {
  @override
  String toString() => 'Increment';
}

class Decrement extends CounterEvent {
  @override
  String toString() => 'Decrement';
}

class CounterBloc extends Bloc<CounterEvent, int> {
  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(int currentState, CounterEvent event) async* {
    if (event is Increment) {
      /// Simulating Network Latency
      await Future<void>.delayed(Duration(seconds: 1));
      yield currentState + 1;
    }
    if (event is Decrement) {
      /// Simulating Network Latency
      await Future<void>.delayed(Duration(milliseconds: 500));
      yield currentState - 1;
    }
  }
}

class SimpleBlocDelegate implements BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition.toString());
  }
}

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();

  final counterBloc = CounterBloc();
  counterBloc.state.listen((data) {
    print(data);
  });
  dynamic al;
  List<int> p = List();
  p.add(1);
  p.add(1);
  p.add(1);
  p[1] = 5;
  print(p);
  try {
    print(al.sd);
  } catch (e) {
    print("error".toString());
  }
  counterBloc.dispatch(Increment());
  counterBloc.dispatch(Increment());
  counterBloc.dispatch(Increment());

  counterBloc.dispatch(Decrement());
  counterBloc.dispatch(Decrement());
  counterBloc.dispatch(Decrement());
}
