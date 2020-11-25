import 'package:flutter/material.dart';

import '../localization/localizations.dart';
import '../service/firebase_service.dart';

class AddTextTestPage extends StatefulWidget {
  final DocumentSnapshot doc;

  const AddTextTestPage({Key key, @required this.doc}) : super(key: key);
  @override
  _AddTextTestPageState createState() => _AddTextTestPageState();
}

class _AddTextTestPageState extends State<AddTextTestPage> {
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
          title: Text(AppLocalizations.of(context).titleTextTest),
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
