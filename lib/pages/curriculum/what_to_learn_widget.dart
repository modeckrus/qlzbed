import 'package:flutter/material.dart';
import '../../localization/localizations.dart';

import '../../my_icons.dart';

class MultipleStringsWidget extends StatefulWidget {
  final Function onAdd;
  final Function onRemove;
  final Function onStart;
  final String title;
  MultipleStringsWidget(
      {Key key, this.onAdd, this.onRemove, @required this.title, this.onStart})
      : super(key: key);

  @override
  _MultipleStringsWidgetState createState() => _MultipleStringsWidgetState();
}

class _MultipleStringsWidgetState extends State<MultipleStringsWidget> {
  TextEditingController _controller;
  List<String> strs = List();
  @override
  void initState() {
    _controller = TextEditingController();
    if (widget.onStart != null) {
      strs.addAll(widget.onStart());
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildChild(String str) {
    return ListTile(
      title: Text(
        str,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: Icon(Icons.check),
      trailing: IconButton(
        icon: Icon(Icons.remove),
        onPressed: () {
          setState(() {
            strs.remove(str);
            if (widget.onRemove != null) {
              widget.onRemove(str);
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> chlds = List();
    for (var str in strs) {
      chlds.add(buildChild(str));
    }
    return Container(
      child: Column(
        children: [
          Text(
            widget.title ?? '',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: chlds,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: _controller,
                  maxLines: null,
                  maxLength: 200,
                  keyboardType: TextInputType.multiline,
                )),
                IconButton(
                    icon: MyIcons.add,
                    onPressed: () {
                      if (_controller.text != null &&
                          _controller.text != '' &&
                          _controller.text != ' ' &&
                          !strs.contains(_controller.text)) {
                        setState(() {
                          strs.add(_controller.text ?? '');
                          if (widget.onAdd != null) {
                            widget.onAdd(_controller.text ?? '');
                          }
                        });
                      }
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
