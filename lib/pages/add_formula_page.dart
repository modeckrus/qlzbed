import 'package:flutter/material.dart';

import '../localization/localizations.dart';

class AddFormulaPage extends StatefulWidget {
  // final DocumentSnapshot doc;

  const AddFormulaPage({Key key}) : super(key: key);
  @override
  _AddFormulaPageState createState() => _AddFormulaPageState();
}

class _AddFormulaPageState extends State<AddFormulaPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
          title: Text(AppLocalizations.of(context).titleAddFormula),
        ),
        body: Column(
          children: [],
        ),
      ),
    );
  }
}
