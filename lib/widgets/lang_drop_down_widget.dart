import 'package:flutter/material.dart';
import 'package:qlzbed/localization/lang_codes.dart';

class LangDropDownButton extends StatefulWidget {
  final Function onlangchange;
  final Function onStart;
  const LangDropDownButton({Key key, @required this.onlangchange, this.onStart})
      : super(key: key);
  @override
  _LangDropDownButtonState createState() => _LangDropDownButtonState();
}

class _LangDropDownButtonState extends State<LangDropDownButton> {
  String lang = 'ru';
  @override
  void initState() {
    super.initState();
    if (widget.onStart != null) {
      final locale = widget.onStart();
      lang = locale;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: lang,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.white),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        widget.onlangchange(newValue);
        setState(() {
          lang = newValue;
        });
      },
      items: LangCodes.codes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        );
      }).toList(),
    );
  }
}
