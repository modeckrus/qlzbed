import 'package:flutter/material.dart';

import '../localization/localizations.dart';
import '../service/firebase_service.dart';
import '../service/fservice.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/sliver_listTile_widget.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).library),
        ),
        body: FutureBuilder(
            future: FirebaseService.collection('routes')
                .document(FService.getLang(context))
                .collection('mainRoutes')
                .get(),
            builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snap) {
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
                        final doc = snap.data[index];
                        return SliverListTile(doc: doc);
                      },
                      childCount: snap.data.length,
                    ),
                  ),
                ],
              );
            }));
  }
}
