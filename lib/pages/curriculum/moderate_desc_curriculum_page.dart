import 'package:flutter/material.dart';

import '../../service/firebase_service.dart';

class ModerateDescCurriculumPage extends StatefulWidget {
  final DocumentSnapshot doc;
  final String learnPath;
  ModerateDescCurriculumPage(
      {Key key, @required this.doc, @required this.learnPath})
      : super(key: key);

  @override
  _ModerateDescCurriculumPageState createState() =>
      _ModerateDescCurriculumPageState();
}

class _ModerateDescCurriculumPageState
    extends State<ModerateDescCurriculumPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Moderate Desc curriculum'),
    );
  }
}
