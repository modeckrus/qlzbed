import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../localization/localizations.dart';
import 'titleBloc/title_bloc.dart';

class TitleEditor extends StatefulWidget {
  final TextEditingController controller;
  TitleEditor({Key key, @required this.controller}) : super(key: key);

  @override
  _TitleEditorState createState() => _TitleEditorState();
}

class _TitleEditorState extends State<TitleEditor> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (String title) {
        BlocProvider.of<TitleBloc>(context).add(TitleChanged(title));
      },
      controller: widget.controller,
      maxLength: 120,
      decoration: InputDecoration(
          errorText: null, labelText: AppLocalizations().justTitle),
    );
  }
}
