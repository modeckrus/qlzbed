import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../entities/fstateMinimum.dart';
import '../service/fservice.dart';
import 'units_view_widget.dart';

class AddUnitWidget extends StatefulWidget {
  final Function onAddLesson;
  final Function onRemoveLesson;
  final Function onStart;
  const AddUnitWidget(
      {Key key,
      @required this.onAddLesson,
      @required this.onRemoveLesson,
      this.onStart})
      : super(key: key);
  @override
  _AddUnitWidgetState createState() => _AddUnitWidgetState();
}

class _AddUnitWidgetState extends State<AddUnitWidget> {
  List<FStateMinimum> lessons = List();
  Function get onAddLesson => widget.onAddLesson;
  Function get onRemoveLesson => widget.onRemoveLesson;

  Widget lessonBuilder(FStateMinimum lesson) {
    Widget icon = FService.getIconByRoute(lesson.route);
    return ListTile(
      trailing: IconButton(
        icon: Icon(Icons.remove),
        onPressed: () {
          setState(() {
            onRemoveLesson(lesson);
            lessons.remove(lesson);
          });
        },
      ),
      title: Text(lesson.title),
      leading: icon,
    );
  }

  @override
  void initState() {
    if (widget.onStart != null) {
      lessons = widget.onStart();
      print(lessons);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> statewidgets = List();
    for (var i = 0; i < lessons.length; i++) {
      statewidgets.add(lessonBuilder(lessons[i]));
    }
    statewidgets.add(
      Container(
        child: IconButton(
          icon: Icon(Icons.add),
          onPressed: () async {
            final DocumentSnapshot docsnap =
                await Navigator.pushNamed(context, '/selectLesson');
            if (docsnap != null) {
              final state = FStateMinimum.fromJson(docsnap.data);
              setState(() {
                lessons.add(state);
                widget.onAddLesson(state);
              });
            }
          },
        ),
      ),
    );
    statewidgets.add(SizedBox(
      height: 20,
    ));
    statewidgets.add(Container(
      height: 400,
      child: UnitsViewWidget(
        lessons: lessons,
      ),
    ));
    return Column(
      children: statewidgets,
    );
  }
}
