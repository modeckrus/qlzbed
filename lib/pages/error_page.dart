import 'package:flutter/material.dart';

import '../localization/localizations.dart';

class ErrorPage extends StatefulWidget {
  final String error;

  const ErrorPage({Key key, @required this.error}) : super(key: key);
  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).error),
        ),
        body: Center(
          child: Text('Error: ' + widget.error),
        ),
      ),
    );
  }
}
