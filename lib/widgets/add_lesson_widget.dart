import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qlzbed/entities/fstate.dart';
import 'package:qlzbed/entities/fstateMinimum.dart';
import 'package:qlzbed/my_icons.dart';
import 'package:qlzbed/service/fservice.dart';

import 'lessons_view_widget.dart';

class AddLessonWidget extends StatefulWidget {
  final Function onAddState;
  final Function onRemoveState;
  final Function onStart;
  const AddLessonWidget(
      {Key key,
      @required this.onAddState,
      @required this.onRemoveState,
      this.onStart})
      : super(key: key);
  @override
  _AddLessonWidgetState createState() => _AddLessonWidgetState();
}

class _AddLessonWidgetState extends State<AddLessonWidget> {
  List<FStateMinimum> states = List();
  Function get onAddState => widget.onAddState;
  Function get onRemoveState => widget.onRemoveState;

  Widget stateBuilder(FStateMinimum state) {
    Widget icon = FService.getIconByRoute(state.route);
    return ListTile(
      trailing: IconButton(
        icon: Icon(Icons.remove),
        onPressed: () {
          setState(() {
            onRemoveState(state);
            states.remove(state);
          });
        },
      ),
      title: Text(state.title),
      leading: icon,
    );
  }

  @override
  void initState() {
    if (widget.onStart != null) {
      states = widget.onStart();
      print(states);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> statewidgets = List();
    for (var i = 0; i < states.length; i++) {
      statewidgets.add(stateBuilder(states[i]));
    }
    statewidgets.add(
      Container(
        child: IconButton(
          icon: Icon(Icons.add),
          onPressed: () async {
            final DocumentSnapshot docsnap =
                await Navigator.pushNamed(context, '/selectState');
            if (docsnap != null) {
              final state = FStateMinimum.fromJson(docsnap.data);
              setState(() {
                states.add(state);
                widget.onAddState(state);
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
      child: LessonsViewWidget(
        states: states,
      ),
    ));
    return Column(
      children: statewidgets,
    );
  }
}
