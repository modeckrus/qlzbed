import 'package:flutter/material.dart';

import '../../localization/localizations.dart';

class CurriculumTitleEditor extends StatefulWidget {
  final TextEditingController controller;
  final Function onChanged;
  CurriculumTitleEditor({Key key, @required this.controller, this.onChanged})
      : super(key: key);

  @override
  _CurriculumTitleEditorState createState() => _CurriculumTitleEditorState();
}

class _CurriculumTitleEditorState extends State<CurriculumTitleEditor> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (String title) {
        if (widget.onChanged != null) {
          widget.onChanged();
        }
      },
      controller: widget.controller,
      maxLength: 120,
      decoration: InputDecoration(
          errorText: null, labelText: AppLocalizations().justTitle),
    );
  }
}
