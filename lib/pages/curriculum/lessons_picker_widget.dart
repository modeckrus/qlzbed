import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../entities/fstateMinimum.dart';
import '../../localization/localizations.dart';
import '../../service/fservice.dart';

class UnitsPickerWidget extends StatefulWidget {
  final Function onAddState;
  final Function onRemoveState;
  final Function onStart;
  const UnitsPickerWidget(
      {Key key,
      @required this.onAddState,
      @required this.onRemoveState,
      this.onStart})
      : super(key: key);
  @override
  _AddLessonWidgetState createState() => _AddLessonWidgetState();
}

class _AddLessonWidgetState extends State<UnitsPickerWidget> {
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

  bool isOk(String r) {
    if (r == '/unit') {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> statewidgets = List();
    for (var i = 0; i < states.length; i++) {
      statewidgets.add(stateBuilder(states[i]));
    }
    statewidgets.add(ListTile(
      leading: Icon(Icons.add),
      title: Text(
        AppLocalizations.of(context).titleAddLesson,
        style: TextStyle(
          fontSize: 24,
        ),
      ),
      onTap: () async {
        final DocumentSnapshot docsnap = await Navigator.pushNamed(
            context, '/selectState',
            arguments: ['/unit']);
        if (docsnap != null) {
          final state = FStateMinimum.fromJson(docsnap.data);
          setState(() {
            states.add(state);
            widget.onAddState(state);
          });
        }
      },
    ));
    statewidgets.add(SizedBox(
      height: 20,
    ));
    return Column(
      children: statewidgets,
    );
  }
}
