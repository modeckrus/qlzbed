//FSpecModerateListPage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qlzbed/widgets/flist_moderate_widget.dart';

import '../my_icons.dart';

class FSpecModerateListPage extends StatefulWidget {
  final DocumentSnapshot doc;

  const FSpecModerateListPage({Key key, @required this.doc}) : super(key: key);
  @override
  _FSpecModerateListPageState createState() => _FSpecModerateListPageState();
}

class _FSpecModerateListPageState extends State<FSpecModerateListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            MyIcons.moderation,
            Text(widget.doc.data['title']),
          ],
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              }),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/addState', arguments: widget.doc);
            },
          ),
        ],
      ),
      body: FModerateListWidget(doc: widget.doc),
    );
  }
}
