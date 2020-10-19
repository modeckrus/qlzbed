import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../authentication/bloc/authentication_bloc.dart';
import '../localization/localizations.dart';
import '../perferences/bloc/perferences_bloc.dart';
import '../widgets/my_animated_flare.dart';

class HelloPage extends StatefulWidget {
  HelloPage({Key key}) : super(key: key);

  @override
  _HelloPageState createState() => _HelloPageState();
}

class _HelloPageState extends State<HelloPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: MyAnimatedFlare(
                    child: FlareActor(
                      "assets/loading.flr",
                      animation: "analysis",
                      fit: BoxFit.fitHeight,
                      alignment: Alignment.center,
                    ),
                  ),
                )),
            Expanded(
                flex: 1,
                child: Text(
                  'Сервис для быстрой мойки \n авто',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
                )),
            Expanded(
                flex: 1,
                child: Text(
                  'БОЛЕЕ 1000 МОЕК ПО АСТАНЕ \n БОЛЕЕ 5000 ПОЛЬЗОВАТЕЛЕЙ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
                )),
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                            BlocProvider.of<PerferencesBloc>(
                                                    context)
                                                .add(PerferencesSettingChanged(
                                                    themeMode:
                                                        ThemeMode.system));
                                          },
                                          title: Text(
                                              AppLocalizations.of(context)
                                                  .systemThemeMode),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            BlocProvider.of<PerferencesBloc>(
                                                    context)
                                                .add(PerferencesSettingChanged(
                                                    themeMode: ThemeMode.dark));
                                          },
                                          title: Text(
                                              AppLocalizations.of(context)
                                                  .darkThemeMode),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            BlocProvider.of<PerferencesBloc>(
                                                    context)
                                                .add(PerferencesSettingChanged(
                                                    themeMode:
                                                        ThemeMode.light));
                                          },
                                          title: Text(
                                              AppLocalizations.of(context)
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
                                return Text(AppLocalizations.of(context)
                                    .systemThemeMode);
                              }
                              if (state.setting.themeMode == ThemeMode.dark) {
                                return Text(
                                    AppLocalizations.of(context).darkThemeMode);
                              }
                              if (state.setting.themeMode == ThemeMode.light) {
                                return Text(AppLocalizations.of(context)
                                    .lightThemeMode);
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
                      mainAxisAlignment: MainAxisAlignment.center,
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
                )),
            Container(
                padding: EdgeInsets.only(bottom: 20, right: 20),
                child: Row(
                  children: [
                    Spacer(),
                    RaisedButton(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      color: Colors.cyan,
                      onPressed: () {
                        // Navigator.pushReplacementNamed(context, '/login');
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(LogPageE());
                      },
                      child: Row(
                        children: [
                          Text(
                            'Продолжить',
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
