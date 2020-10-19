import 'package:bloc/bloc.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print('Event: ' + event.toString() + '; Bloc: ' + bloc.toString());
    super.onEvent(bloc, event);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stacktrace) {
    // print('Error: ' +
    //     error.toString() +
    //     '; bloc: ' +
    //     bloc.toString() +
    //     '; stacktrace: ' +
    //     stacktrace.toString());
    super.onError(cubit, error, stacktrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(
        'Transition: ' + transition.toString() + '; bloc: ' + bloc.toString());
    super.onTransition(bloc, transition);
  }
}
