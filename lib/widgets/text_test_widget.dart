import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TextTestWidget extends StatefulWidget {
  final DocumentSnapshot doc;

  const TextTestWidget({Key key, @required this.doc}) : super(key: key);
  @override
  _TextTestWidgetState createState() => _TextTestWidgetState();
}

class _TextTestWidgetState extends State<TextTestWidget> {
  DocumentSnapshot get doc => widget.doc;
  TextEditingController _editingController;

  @override
  void initState() {
    _editingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
