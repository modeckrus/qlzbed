import 'package:flutter/material.dart';

import '../entities/fstateMinimum.dart';

class CheckTestWidget extends StatefulWidget {
  final FStateMinimum state;

  const CheckTestWidget({Key key, this.state}) : super(key: key);
  @override
  _CheckTestWidgetState createState() => _CheckTestWidgetState();
}

class _CheckTestWidgetState extends State<CheckTestWidget> {
  FStateMinimum get state => widget.state;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
