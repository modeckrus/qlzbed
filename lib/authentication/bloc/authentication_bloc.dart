import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../entities/user.dart';
import '../../service/firebase_service.dart';
import '../../user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  StreamSubscription<AuthenticationState> _streamSubscription;

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }

  AuthenticationBloc({@required this.userRepository}) : super(Uninitialized());
  // @override
  // AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    } else if (event is SingedUp) {
      yield SettingUser();
    } else if (event is WannaLogIn) {
      yield Unauthenticated();
    } else if (event is LogPageE) {
      yield LogPageS();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await userRepository.isSignedIn();
      if (isSignedIn) {
        final user = await userRepository.getUser();
        if (GetIt.I.isRegistered<User>()) {
          GetIt.I.unregister<User>();
        }
        GetIt.I.registerSingleton<User>(user);
        final userSnap =
            await FirebaseService.collection('user').document(user.uid).get();
        if (userSnap.exists) {
          final userData =
              User.fromJson(userSnap.data ?? Map<String, dynamic>());
          if (userData != null && userData.isSetted) {
            if (GetIt.I.isRegistered<User>() && GetIt.I.get<User>() != null) {
              GetIt.I.unregister<User>();
            }
            GetIt.I.registerSingleton<User>(userData);
            print('User registred: ' + GetIt.I.get<User>().toString());
            yield Authenticated(user);
          } else {
            yield SettingUser();
          }
        } else {
          yield SettingUser();
        }
      } else {
        // final user = await userRepository.anonAuth();
        // if (GetIt.I.isRegistered<User>()) {
        //   GetIt.I.unregister<User>();
        // }
        // GetIt.I.registerSingleton<User>(user);
        // yield Authenticated(user);
        yield Unauthenticated();
      }
    } catch (e) {
      print('error while auth: ' + e.toString());
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    try {
      final user = await userRepository.getUser();
      if (GetIt.I.isRegistered<User>()) {
        GetIt.I.unregister<User>();
      }
      GetIt.I.registerSingleton<User>(user);
      final userSnap =
          await FirebaseService.collection('user').document(user.uid).get();
      if (userSnap.exists) {
        final userData = User.fromJson(userSnap.data ?? Map<String, dynamic>());
        if (userData != null && userData.isSetted) {
          if (GetIt.I.isRegistered<User>() && GetIt.I.get<User>() != null) {
            GetIt.I.unregister<User>();
          }
          GetIt.I.registerSingleton<User>(userData);
          print('User registred: ' + GetIt.I.get<User>().toString());
          yield Authenticated(user);
        } else {
          yield SettingUser();
        }
      } else {
        yield SettingUser();
      }
    } catch (e) {
      print(e);
    }

    // yield Authenticated(user);
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    userRepository.signOut();
  }
}
