import 'package:flutter/material.dart';
import 'package:qlzbed/entities/fstateMinimum.dart';
import 'package:qlzbed/widgets/text_test_widget.dart';

import 'article_widget.dart';
import 'check_test_widget.dart';

class StateBuilderWidget extends StatefulWidget {
  final FStateMinimum state;

  const StateBuilderWidget({Key key, @required this.state}) : super(key: key);
  @override
  _StateBuilderWidgetState createState() => _StateBuilderWidgetState();
}

class _StateBuilderWidgetState extends State<StateBuilderWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.state.route) {
      case '/article':
        return ArticleWidget(state: widget.state);
        break;
      case '/textTest':
        return TextTestWidget(state: widget.state);
      case '/checkTest':
        return CheckTestWidget(state: widget.state);
        break;
      default:
        return Container();
    }
  }
}
