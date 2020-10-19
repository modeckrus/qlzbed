import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../localization/localizations.dart';
import '../widgets/error_widget.dart';
import '../widgets/listTile_widget.dart';
import '../widgets/loading_widget.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).feed),
        ),
        body: StreamBuilder(
          stream: Firestore.instance
              .collection('user')
              .document(GetIt.I.get<FirebaseUser>().uid)
              .collection('feed')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return FErrorWidget(error: snapshot.error);
            }
            if (!snapshot.hasData) {
              return LoadingWidget();
            }

            QuerySnapshot data = snapshot.data;
            return ListView.builder(
                itemCount: data.documents.length,
                itemBuilder: (context, index) {
                  return FListTile(doc: data.documents[index]);
                });
          },
        ));
  }
}
