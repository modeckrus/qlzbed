import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../setting.dart';

part 'perferences_event.dart';
part 'perferences_state.dart';

class PerferencesBloc extends Bloc<PerferencesEvent, PerferencesState> {
  PerferencesBloc() : super(PerferencesLoading());
  var preferences = Hive.box('perference');
  Setting setting;
  @override
  Stream<PerferencesState> mapEventToState(
    PerferencesEvent event,
  ) async* {
    if (event is PerferencesAppStarted) {
      final initsetting = Setting(
          lang: preferences.get('lang'),
          themeMode: themeModeFromString(preferences.get('themeMode')));
      setting = initsetting;
      yield PerferencesLoaded(setting);
    }
    if (event is PerferencesSettingChanged) {
      if (event.lang != null) {
        await preferences.put('lang', event.lang);
        final ThemeMode themeMode =
            setting.themeMode == null ? ThemeMode.system : setting.themeMode;
        setting = Setting(lang: event.lang, themeMode: themeMode);
      }
      if (event.themeMode != null) {
        await preferences.put('themeMode', themeModeToString(event.themeMode));
        final lang = setting.lang == null ? 'ru' : setting.lang;
        setting = Setting(lang: lang, themeMode: event.themeMode);
      }
      yield PerferencesLoaded(setting);
    }
  }
}

ThemeMode themeModeFromString(String string) {
  switch (string) {
    case 'system':
      return ThemeMode.system;
    case 'dark':
      return ThemeMode.dark;
    case 'light':
      return ThemeMode.light;
      break;
    default:
      return ThemeMode.system;
  }
}

String themeModeToString(ThemeMode themeMode) {
  switch (themeMode) {
    case ThemeMode.system:
      return 'system';
    case ThemeMode.light:
      return 'light';
    case ThemeMode.dark:
      return 'dark';
      break;
    default:
      return 'system';
  }
}
