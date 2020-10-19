import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../setting.dart';

part 'perferences_event.dart';
part 'perferences_state.dart';

class PerferencesBloc extends Bloc<PerferencesEvent, PerferencesState> {
  PerferencesBloc() : super(PerferencesLoading());
  SharedPreferences preferences;
  Setting setting;
  @override
  Stream<PerferencesState> mapEventToState(
    PerferencesEvent event,
  ) async* {
    if (event is PerferencesAppStarted) {
      preferences = await SharedPreferences.getInstance();
      final initsetting = Setting(
          lang: preferences.get('lang'),
          themeMode: themeModeFromString(preferences.get('themeMode')));
      setting = initsetting;
      yield PerferencesLoaded(setting);
    }
    if (event is PerferencesSettingChanged) {
      if (event.lang != null) {
        final isOkLang = await preferences.setString('lang', event.lang);
        if (isOkLang) {
          final ThemeMode themeMode =
              setting.themeMode == null ? ThemeMode.system : setting.themeMode;
          setting = Setting(lang: event.lang, themeMode: themeMode);
        }
      }
      if (event.themeMode != null) {
        final isOkThemeMode = await preferences.setString(
            'themeMode', themeModeToString(event.themeMode));
        if (isOkThemeMode) {
          final lang = setting.lang == null ? 'ru' : setting.lang;
          setting = Setting(lang: lang, themeMode: event.themeMode);
        }
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
