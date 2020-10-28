import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qlzbed/service/fservice.dart';
import 'package:qlzbed/widgets/moderate_sliver_listTile_widget.dart';

import '../localization/localizations.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/sliver_listTile_widget.dart';

class ModerateLibraryWidget extends StatefulWidget {
  @override
  _ModerateLibraryWidgetState createState() => _ModerateLibraryWidgetState();
}

class _ModerateLibraryWidgetState extends State<ModerateLibraryWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('moderation')
            .document(FService.getLang(context))
            .collection('mainRoutes')
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return LoadingWidget();
          }
          if (snap.hasError) {
            return FErrorWidget(error: snap.error.toString());
          }

          var countryCode = FService.getLang(context);
          print({'Locale: ': countryCode});
          // QuerySnapshot querySnap = snap.data;
          // print(querySnap.documents);
          //print(snap.data.documents['Title'].data['title']);
          return CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final doc = snap.data.documents[index];
                    return ModerateSliverListTile(doc: doc);
                  },
                  childCount: snap.data.documents.length,
                ),
              ),
            ],
          );
        });
  }
}
