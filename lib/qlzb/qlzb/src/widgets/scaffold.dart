import 'package:flutter/material.dart';

import 'editor.dart';

/// Provides necessary layout for [QlzbEditor].
class QlzbScaffold extends StatefulWidget {
  final Widget child;

  const QlzbScaffold({Key key, this.child}) : super(key: key);

  static QlzbScaffoldState of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<_QlzbScaffoldAccess>();
    return widget.scaffold;
  }

  @override
  QlzbScaffoldState createState() => QlzbScaffoldState();
}

class QlzbScaffoldState extends State<QlzbScaffold> {
  WidgetBuilder _toolbarBuilder;

  void showToolbar(WidgetBuilder builder) {
    setState(() {
      _toolbarBuilder = builder;
    });
  }

  void hideToolbar(WidgetBuilder builder) {
    if (_toolbarBuilder == builder) {
      setState(() {
        _toolbarBuilder = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final toolbar =
        (_toolbarBuilder == null) ? Container() : _toolbarBuilder(context);
    return _QlzbScaffoldAccess(
      scaffold: this,
      child: Column(
        children: <Widget>[
          Expanded(child: widget.child),
          toolbar,
        ],
      ),
    );
  }
}

class _QlzbScaffoldAccess extends InheritedWidget {
  final QlzbScaffoldState scaffold;

  _QlzbScaffoldAccess({Widget child, this.scaffold}) : super(child: child);

  @override
  bool updateShouldNotify(_QlzbScaffoldAccess oldWidget) {
    return oldWidget.scaffold != scaffold;
  }
}
