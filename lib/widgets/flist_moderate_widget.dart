import 'package:flutter/material.dart';

import '../service/firebase_service.dart';
import 'loading_widget.dart';
import 'moderate_sliver_listTile_widget.dart';

class FModerateListWidget extends StatefulWidget {
  final DocumentSnapshot doc;

  const FModerateListWidget({Key key, @required this.doc}) : super(key: key);
  @override
  _FModerateListWidgetState createState() => _FModerateListWidgetState();
}

class _FModerateListWidgetState extends State<FModerateListWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseService.collection(
              widget.doc.reference.path + '/moderationList')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!(snapshot.hasData)) {
          return LoadingWidget();
        }
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error);
        }

        List<DocumentSnapshot> data = snapshot.data;
        return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ModerateSliverListTile(doc: data[index]);
            });
      },
    );
  }
}
