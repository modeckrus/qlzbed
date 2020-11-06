import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../my_icons.dart';
import '../../widgets/flist_moderate_widget.dart';

class ModerateGroupPage extends StatefulWidget {
  final DocumentSnapshot doc;

  const ModerateGroupPage({Key key, @required this.doc}) : super(key: key);
  @override
  _ModerateGroupPageState createState() => _ModerateGroupPageState();
}

class _ModerateGroupPageState extends State<ModerateGroupPage> {
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
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.pushNamed(context, '/moderateAddGroup',
                  arguments: widget.doc);
            },
          ),
        ],
      ),
      body: FModerateListWidget(doc: widget.doc),
    );
  }
}
