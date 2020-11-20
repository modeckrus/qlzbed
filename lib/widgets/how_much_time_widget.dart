import 'package:flutter/material.dart';

class HowMuchTimeWidget extends StatefulWidget {
  final Function onChange;
  final Function onStart;
  HowMuchTimeWidget({Key key, @required this.onChange, this.onStart})
      : super(key: key);

  @override
  _HowMuchTimeWidgetState createState() => _HowMuchTimeWidgetState();
}

class _HowMuchTimeWidgetState extends State<HowMuchTimeWidget> {
  TextEditingController _controller;
  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    if (widget.onStart != null) {
      final val = widget.onStart();
      _controller.text = val.toString();
    }
    _controller.addListener(() {
      final num = int.parse(_controller.text);
      widget.onChange(num);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
      ),
    );
  }
}
