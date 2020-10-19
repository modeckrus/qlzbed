import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

class MZefyrReadingWidget extends StatefulWidget {
  final NotusDocument document;

  const MZefyrReadingWidget({Key key, @required this.document})
      : super(key: key);
  @override
  _MZefyrReadingWidgetState createState() => _MZefyrReadingWidgetState();
}

class _MZefyrReadingWidgetState extends State<MZefyrReadingWidget> {
  ZefyrController _zefyrController;
  FocusNode focusNode;
  @override
  void initState() {
    _zefyrController = ZefyrController(widget.document);
    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
