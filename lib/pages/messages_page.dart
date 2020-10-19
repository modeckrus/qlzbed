import 'package:flutter/material.dart';

import '../localization/localizations.dart';
import '../widgets/dialogs_list_widget.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).messages),
      ),
      body: DialogsListWidget(),
    );
  }
}
