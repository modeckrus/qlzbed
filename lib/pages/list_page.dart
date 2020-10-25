import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/list_widget.dart';

class FListPage extends StatefulWidget {
  final DocumentSnapshot doc;

  const FListPage({Key key, @required this.doc}) : super(key: key);
  @override
  _FListPageState createState() => _FListPageState();
}

class _FListPageState extends State<FListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doc.data['title']),
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
      body: FListWidget(doc: widget.doc),
    );
  }
}
