import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qlzbed/entities/fstateMinimum.dart';

class TextTestWidget extends StatefulWidget {
  final FStateMinimum state;

  const TextTestWidget({Key key, @required this.state}) : super(key: key);
  @override
  _TextTestWidgetState createState() => _TextTestWidgetState();
}

class _TextTestWidgetState extends State<TextTestWidget> {
  FStateMinimum get state => widget.state;
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
