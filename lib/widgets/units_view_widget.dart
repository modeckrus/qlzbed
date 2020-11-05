import 'package:flutter/material.dart';
import 'package:qlzbed/entities/fstateMinimum.dart';
import 'package:qlzbed/entities/lesson.dart';
import 'package:qlzbed/widgets/state_builder_widget.dart';

class UnitsViewWidget extends StatefulWidget {
  final List<FStateMinimum> lessons;

  const UnitsViewWidget({Key key, @required this.lessons}) : super(key: key);
  @override
  _UnitsViewWidgetState createState() => _UnitsViewWidgetState();
}

class _UnitsViewWidgetState extends State<UnitsViewWidget> {
  @override
  void initState() {
    super.initState();
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
    for (var i = 0; i < widget.lessons.length; i++) {
      children.add(buildLesson(widget.lessons[i]));
    }
    if (children.length == 0) {
      children.add(Container());
    }
    return ListView(
      children: children,
    );
  }
}
