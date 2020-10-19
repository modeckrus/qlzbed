import 'package:flutter/material.dart';

class FErrorWidget extends StatefulWidget {
  final String error;

  const FErrorWidget({Key key, this.error}) : super(key: key);
  @override
  _FErrorWidgetState createState() => _FErrorWidgetState();
}

class _FErrorWidgetState extends State<FErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        widget.error ?? 'Error',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
