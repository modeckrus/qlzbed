import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).account),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              })
        ],
      ),
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
              child: DisplayUserWidget(),
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
    );
  }
}
