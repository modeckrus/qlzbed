import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../entities/user.dart';
import '../../service/firebase_service.dart';

part 'settinguser_event.dart';
part 'settinguser_state.dart';

class SettinguserBloc extends Bloc<SettinguserEvent, SettinguserState> {
  SettinguserBloc() : super(SettinguserRead());
  User user;
  @override
  Stream<SettinguserState> mapEventToState(
    SettinguserEvent event,
  ) async* {
    if (event is SettinguserChange) {
      user = event.user;
      if (user.isSetted) {
        yield SettinguserEditState();
      } else {
        yield SettinguserNotFull();
      }
    }
    if (event is SettinguserStartEditing) {
      if (user == null) {
        yield SettinguserNotFull();
      } else {
        if (user.isSetted) {
          yield SettinguserEditState();
        } else {
          yield SettinguserNotFull();
        }
      }
    }
    if (event is SettinguserSave) {
      yield SettinguserLoading();
      try {
        final userDoc = await FirebaseService.collection('user')
            .document(GetIt.I.get<User>().uid)
            .get();
        await userDoc.reference.updateData(user.toJson());

        yield SettinguserSucces();
        if (GetIt.I.isRegistered<User>() && GetIt.I.get<User>() != null) {
          GetIt.I.unregister<User>();
          // GetIt.I.registerSingleton<User>(user);
        }
        GetIt.I.registerSingleton<User>(user);
        await Future.delayed(Duration(seconds: 2));
        yield SettinguserRead();
      } catch (e) {
        yield SettinguserError(e);
        await Future.delayed(Duration(seconds: 1));
        yield SettinguserRead();
      }
    }
  }
}
