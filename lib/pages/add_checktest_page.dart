import 'package:flutter/material.dart';

import '../localization/localizations.dart';
import '../service/firebase_service.dart';

class AddCheckTestPage extends StatefulWidget {
  final DocumentSnapshot doc;

  const AddCheckTestPage({Key key, @required this.doc}) : super(key: key);
  @override
  _AddCheckTestPageState createState() => _AddCheckTestPageState();
}

class _AddCheckTestPageState extends State<AddCheckTestPage> {
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
          title: Text(AppLocalizations.of(context).titleCheckTest),
        ),
        body: Column(
          children: [
            Text(
              AppLocalizations.of(context).path +
                  ': \n' +
                  widget.doc.reference.path,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
              ),
            )
          ],
        ),
      ),
    );
  }
}
