import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:qlzbed/my_icons.dart';
import 'package:qlzbed/settingUser/settinguserbloc/settinguser_bloc.dart';
import 'package:qlzbed/widgets/settings_user_widget.dart';

import '../authentication/bloc/authentication_bloc.dart';
import '../localization/localizations.dart';
import '../widgets/add_avatar_widget.dart';
import '../widgets/display_user_widget.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SettinguserBloc(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).account),
            actions: [
              IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(LoggedOut());
                  })
            ],
          ),
          floatingActionButton: BlocBuilder<SettinguserBloc, SettinguserState>(
              // cubit: BlocProvider.of<SettinguserBloc>(context),
              builder: (context, state) {
            if (state is SettinguserRead) {
              return FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () {
                  BlocProvider.of<SettinguserBloc>(context)
                      .add(SettinguserStartEditing());
                },
              );
            }
            if (state is SettinguserEditState) {
              return FloatingActionButton(
                child: Icon(Icons.save),
                onPressed: () {
                  BlocProvider.of<SettinguserBloc>(context)
                      .add(SettinguserSave());
                },
              );
            }
            if (state is SettinguserError) {
              return FloatingActionButton(
                onPressed: null,
                child: Icon(Icons.error),
              );
            }
            if (state is SettinguserLoading) {
              return FloatingActionButton(
                child: CircularProgressIndicator(),
                onPressed: null,
              );
            }
            if (state is SettinguserSucces) {
              return FloatingActionButton(
                child: Icon(Icons.check),
                backgroundColor: Colors.green,
                onPressed: null,
              );
            }
            if (state is SettinguserNotFull) {
              return FloatingActionButton(
                onPressed: null,
                backgroundColor: Colors.orange,
                child: Icon(
                  Icons.cached,
                ),
              );
            }
            return Container();
          }),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Builder(
                    builder: (context) {
                      return AddAvatarWidget(onAddImage: (String path) async {
                        Firestore.instance
                            .collection('user')
                            .document(GetIt.I.get<FirebaseUser>().uid)
                            .updateData({'Avatar': path}).then((value) {
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Avatar Setted')));
                          // Firestore.instance
                          //     .collection('user')
                          //     .document(GetIt.I.get<FirebaseUser>().uid)
                          //     .get()
                          //     .then((docsnap) {
                          //   final user = User.fromJson(docsnap.data);
                          //   if (GetIt.I.get<User>() != null) {
                          //     GetIt.I.unregister<User>();
                          //     GetIt.I.registerSingleton<User>(user);
                          //   }
                          //   GetIt.I.registerSingleton<User>(user);
                          // });
                        });
                      });
                    },
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocListener<SettinguserBloc, SettinguserState>(
                    listener: (context, state) {
                      if (state is SettinguserRead) {
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(AppStarted());
                      }
                    },
                    child: BlocBuilder<SettinguserBloc, SettinguserState>(
                        // cubit: BlocProvider.of<SettinguserBloc>(context),
                        builder: (context, state) {
                      if (state is SettinguserRead) {
                        return DisplayUserWidget();
                      }
                      if (state is SettinguserEditState ||
                          state is SettinguserNotFull) {
                        return SettingsUserWidget();
                      }
                      if (state is SettinguserError) {
                        return Container(
                          child: Text(state.error.toString()),
                        );
                      }
                      if (state is SettinguserLoading) {
                        return Container(
                          child: LinearProgressIndicator(),
                        );
                      }
                      if (state is SettinguserSucces) {
                        return Column(
                          children: [
                            DisplayUserWidget(),
                            Container(
                              height: 10,
                              width: double.infinity,
                              color: Colors.green,
                            )
                          ],
                        );
                      }
                      return Container();
                    }),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/test');
                  },
                  title: Text('Test'),
                  leading: Icon(Icons.text_fields_sharp),
                  trailing: Icon(Icons.navigate_next),
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/moderation');
                  },
                  title: Text(AppLocalizations.of(context).moderationTitle),
                  leading: MyIcons.moderation,
                  trailing: Icon(Icons.navigate_next),
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  title: Text(AppLocalizations.of(context).settings),
                  leading: Icon(Icons.settings),
                  trailing: Icon(Icons.navigate_next),
                ),
                Divider(),
              ],
            ),
          ),
        ));
  }
}
