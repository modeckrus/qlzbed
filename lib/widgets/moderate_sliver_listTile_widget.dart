import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qlzbed/entities/moderationState.dart';
import 'package:qlzbed/my_icons.dart';

class ModerateSliverListTile extends StatefulWidget {
  ModerateSliverListTile({Key key, @required this.doc}) : super(key: key);
  final DocumentSnapshot doc;
  @override
  _ModerateSliverListTileState createState() => _ModerateSliverListTileState();
}

class _ModerateSliverListTileState extends State<ModerateSliverListTile> {
  @override
  Widget build(BuildContext context) {
    final state = ModerationState.fromJson(widget.doc.data);
    Widget icon = MyIcons.article;
    String route = '/';
    if (state.route == '/article') {
      icon = MyIcons.article;
      route = '/moderateArticle';
    }
    if (state.route == '/testText') {
      icon = MyIcons.textTest;
      route = '/moderateTestText';
    }
    if (state.route == '/checkTest') {
      icon = MyIcons.checkTest;
      route = '/moderateCheckTest';
    }
    if (state.route == '/list') {
      icon = MyIcons.group;
      route = '/moderateList';
    }
    bool isModerating = state.isModerating;
    if (isModerating == null) {
      isModerating = true;
    }
    return GestureDetector(
      onTap: () async {
        print('tapped');
        Navigator.pushNamed(context, isModerating ? route : state.route,
            arguments: widget.doc);
      },
      child: Container(
        height: 80,
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            color: Colors.black38,
            child: ListTile(
              leading: icon,
              title: Text(
                widget.doc.data['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              trailing: Icon(isModerating ? Icons.public_off : Icons.public),
            ),
          ),
        ),
      ),
    );
  }
}
