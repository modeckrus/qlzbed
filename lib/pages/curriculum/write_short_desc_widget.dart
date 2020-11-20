import 'package:flutter/material.dart';

class WriteShortDescWidget extends StatefulWidget {
  final TextEditingController controller;
  WriteShortDescWidget({Key key, @required this.controller}) : super(key: key);

  @override
  _WriteShortDescWidgetState createState() => _WriteShortDescWidgetState();
}

class _WriteShortDescWidgetState extends State<WriteShortDescWidget> {
  TextEditingController get controller => widget.controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        maxLines: null,
        maxLength: 200,
        controller: controller,
      ),
    );
  }
}
