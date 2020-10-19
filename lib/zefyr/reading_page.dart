import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notus/notus.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

import '../localization/localizations.dart';
import '../service/fstore_cahe_manager.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import 'm_zefyr_reading_widget.dart';

class ReadingPage extends StatefulWidget {
  final DocumentSnapshot doc;

  const ReadingPage({Key key, @required this.doc}) : super(key: key);
  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  Future<NotusDocument> _loadDocument() async {
    final path = widget.doc.data['path'];
    final Delta delta = Delta()
      ..insert(AppLocalizations.of(context).somethingWentWrond);
    final file = await FStoreCacheManager().getFStoreFile(path);

    if (await file.exists()) {
      final String contents = await file.readAsString();
      if (contents == null || contents == '') {
        return NotusDocument.fromDelta(delta);
      }
      return NotusDocument.fromJson(jsonDecode(contents));
    }

    return NotusDocument.fromDelta(delta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doc.data['title'] ?? ''),
        actions: [
          IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              })
        ],
      ),
      body: FutureBuilder(
        future: _loadDocument(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return FErrorWidget(
              error: snapshot.error,
            );
          }
          if (!snapshot.hasData) {
            return LoadingWidget();
          }
          return MZefyrReadingWidget(document: snapshot.data);
        },
      ),
    );
  }
}
