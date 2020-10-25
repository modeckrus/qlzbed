import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qlzbed/localization/localizations.dart';

class AddArticlePage extends StatefulWidget {
  final DocumentSnapshot doc;

  const AddArticlePage({Key key, @required this.doc}) : super(key: key);
  @override
  _AddArticlePageState createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
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
          title: Text(AppLocalizations.of(context).titleAddArticle),
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
