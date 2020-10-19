import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FListTile extends StatefulWidget {
  final DocumentSnapshot doc;

  const FListTile({Key key, @required this.doc}) : super(key: key);
  @override
  _FListTileState createState() => _FListTileState();
}

class _FListTileState extends State<FListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, widget.doc.data['route']);
      },
      title: Text(widget.doc.data['title']),
    );
  }
}
