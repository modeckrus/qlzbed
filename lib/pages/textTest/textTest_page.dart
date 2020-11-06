import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../entities/fstateMinimum.dart';
import '../../widgets/text_test_widget.dart';

class TextTestPage extends StatefulWidget {
  final DocumentSnapshot doc;

  const TextTestPage({Key key, @required this.doc}) : super(key: key);
  @override
  _TextTestPageState createState() => _TextTestPageState();
}

class _TextTestPageState extends State<TextTestPage> {
  DocumentSnapshot get doc => widget.doc;
  FStateMinimum state;
  @override
  void initState() {
    state = FStateMinimum.fromJson(doc.data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: TextTestWidget(
          state: state,
        ),
      ),
    );
  }
}
