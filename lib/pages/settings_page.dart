import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../localization/localizations.dart';
import '../perferences/bloc/perferences_bloc.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context).themeOfApp,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  width: 5,
                ),
                FlatButton(
                  padding: EdgeInsets.all(12),
                  color: Colors.black26,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  onTap: () {
                                    BlocProvider.of<PerferencesBloc>(context)
                                        .add(PerferencesSettingChanged(
                                            themeMode: ThemeMode.system));
                                  },
                                  title: Text(AppLocalizations.of(context)
                                      .systemThemeMode),
                                ),
                                ListTile(
                                  onTap: () {
                                    BlocProvider.of<PerferencesBloc>(context)
                                        .add(PerferencesSettingChanged(
                                            themeMode: ThemeMode.dark));
                                  },
                                  title: Text(AppLocalizations.of(context)
                                      .darkThemeMode),
                                ),
                                ListTile(
                                  onTap: () {
                                    BlocProvider.of<PerferencesBloc>(context)
                                        .add(PerferencesSettingChanged(
                                            themeMode: ThemeMode.light));
                                  },
                                  title: Text(AppLocalizations.of(context)
                                      .lightThemeMode),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: BlocBuilder<PerferencesBloc, PerferencesState>(
                      builder: (context, state) {
                    if (state is PerferencesLoaded) {
                      if (state.setting.themeMode == ThemeMode.system) {
                        return Text(
                            AppLocalizations.of(context).systemThemeMode);
                      }
                      if (state.setting.themeMode == ThemeMode.dark) {
                        return Text(AppLocalizations.of(context).darkThemeMode);
                      }
                      if (state.setting.themeMode == ThemeMode.light) {
                        return Text(
                            AppLocalizations.of(context).lightThemeMode);
                      }
                      return Container();
                    }
                    return Container();
                  }),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Язык приложения:',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  width: 5,
                ),
                FlatButton(
                  padding: EdgeInsets.all(12),
                  color: Colors.black26,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: Text('Русский'),
                                ),
                                ListTile(
                                  title: Text('Казакский'),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Text('Русский'),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
