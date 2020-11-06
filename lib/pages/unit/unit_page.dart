import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../entities/fstateMinimum.dart';
import '../../entities/unit.dart';
import '../../my_icons.dart';
import '../../service/dialog_sevice.dart';

class UnitPage extends StatefulWidget {
  final DocumentSnapshot doc;

  const UnitPage({Key key, @required this.doc}) : super(key: key);
  @override
  _UnitPageState createState() => _UnitPageState();
}

class _UnitPageState extends State<UnitPage> {
  Unit unit;
  @override
  void initState() {
    super.initState();
    unit = Unit.fromJson(widget.doc.data);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildLesson(FStateMinimum lesson) {
    return ListTile(
      title: Text(lesson.title),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List();
    for (var i = 0; i < unit.lessons.length; i++) {
      children.add(buildLesson(unit.lessons[i]));
    }
    if (children.length == 0) {
      children.add(Container());
    }
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(unit.title),
          actions: [
            IconButton(
              icon: MyIcons.more,
              onPressed: () {
                DialogService.showMoreDialog(context, widget.doc.reference);
              },
            ),
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            )
          ],
        ),
        body: ListView(
          children: children,
        ),
      ),
    );
  }
}
