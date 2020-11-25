import 'package:flutter/material.dart';

import '../service/firebase_service.dart';
import 'loading_widget.dart';
import 'sliver_listTile_widget.dart';

class FListWidget extends StatefulWidget {
  final DocumentSnapshot doc;

  const FListWidget({Key key, @required this.doc}) : super(key: key);
  @override
  _FListWidgetState createState() => _FListWidgetState();
}

class _FListWidgetState extends State<FListWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseService.collection(widget.doc.reference.path + '/list')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!(snapshot.hasData)) {
          return LoadingWidget();
        }
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error);
        }

        QuerySnapshot data = snapshot.data;
        return ListView.builder(
            itemCount: data.documents.length,
            itemBuilder: (context, index) {
              return SliverListTile(doc: data.documents[index]);
            });
      },
    );
  }
}
