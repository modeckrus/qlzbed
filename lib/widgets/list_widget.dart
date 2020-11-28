import 'package:flutter/cupertino.dart';
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
  ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future:
          FirebaseService.collection(widget.doc.reference.path + '/list').get(),
      builder: (BuildContext context,
          AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (!(snapshot.hasData)) {
          return LoadingWidget();
        }
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error);
        }

        List<DocumentSnapshot> data = snapshot.data;
        return CupertinoScrollbar(
          controller: _scrollController,
          child: ListView.builder(
              controller: _scrollController,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return SliverListTile(doc: data[index]);
              }),
        );
      },
    );
  }
}
