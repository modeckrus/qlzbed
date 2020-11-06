import 'package:flutter/material.dart';

import '../entities/fstateMinimum.dart';
import 'state_builder_widget.dart';

class LessonsViewWidget extends StatefulWidget {
  final List<FStateMinimum> states;

  const LessonsViewWidget({Key key, @required this.states}) : super(key: key);
  @override
  _LessonsViewWidgetState createState() => _LessonsViewWidgetState();
}

class _LessonsViewWidgetState extends State<LessonsViewWidget> {
  PageController _pageController;
  @override
  void initState() {
    _pageController = PageController(
      initialPage: 1,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget buildState(FStateMinimum state) {
    return StateBuilderWidget(
      state: state,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List();
    for (var i = 0; i < widget.states.length; i++) {
      children.add(buildState(widget.states[i]));
    }
    if (children.length == 0) {
      children.add(Container());
    }
    return PageView(
      controller: _pageController,
      children: children,
    );
  }
}
