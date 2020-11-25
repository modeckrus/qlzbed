// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:qlzbed/entities/user.dart';
import 'package:qlzbed/service/firebase_service.dart';

import '../authentication/bloc/authentication_bloc.dart';
import '../widgets/add_avatar_widget.dart';
import '../widgets/display_user_widget.dart';
import '../widgets/settings_user_widget.dart';
import 'settinguserbloc/settinguser_bloc.dart';

class SettingUserPage extends StatefulWidget {
  static const String route = '/settinguser';
  SettingUserPage({Key key}) : super(key: key);

  @override
  _SettingUserPageState createState() => _SettingUserPageState();
}

class _SettingUserPageState extends State<SettingUserPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettinguserBloc>(
      create: (context) => SettinguserBloc()..add(SettinguserStartEditing()),
      child: SafeArea(
        child: Scaffold(
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
          body: buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Builder(
                builder: (context) {
                  return AddAvatarWidget(onAddImage: (String path) async {
                    FirebaseService.collection('user')
                        .document(GetIt.I.get<User>().uid)
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
            BlocListener<SettinguserBloc, SettinguserState>(
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
          ],
        ),
      ),
    );
  }
}
