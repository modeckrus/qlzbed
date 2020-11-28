import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../entities/user.dart';
import '../localization/localizations.dart';
import '../service/firebase_service.dart';
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
        body: FutureBuilder(
          future: Future.delayed(Duration(milliseconds: 500)),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            return StreamBuilder(
              stream: FirebaseService.collection('user')
                  .document(GetIt.I.get<User>().uid)
                  .collection('feed')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return FErrorWidget(error: snapshot.error);
                }
                if (!snapshot.hasData) {
                  return LoadingWidget();
                }

                List<DocumentSnapshot> data = snapshot.data;
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return FListTile(doc: data[index]);
                    });
              },
            );
          },
        ));
  }
}
