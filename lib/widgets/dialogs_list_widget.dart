// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qlzbed/entities/user.dart';
import 'package:qlzbed/service/firebase_service.dart';

import '../entities/dialog.dart';
import 'dialog_tile_widget.dart';
import 'firestore_animated_list.dart';

class DialogsListWidget extends StatefulWidget {
  @override
  _DialogsListWidgetState createState() => _DialogsListWidgetState();
}

class _DialogsListWidgetState extends State<DialogsListWidget> {
  @override
  Widget build(BuildContext context) {
    return FirestoreAnimatedList(
        query: FirebaseService.collection('user')
            .document(GetIt.I.get<User>().uid)
            .collection('dialogs')
            .orderBy('isPinned', descending: true),
        // .orderBy('missedMessages', descending: true),
        itemBuilder: (context, snapshot, animation, index) {
          final dialog = MDialog.fromJson(snapshot.data);
          print('Itembuilder of dialog ' + dialog.toString());
          return SizeTransition(
            sizeFactor: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            axisAlignment: 0.0,
            child: DialogTileWidget(dialog: dialog),
          );
        });
  }
}
