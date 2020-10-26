import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qlzbed/entities/user.dart';
import 'package:qlzbed/localization/localizations.dart';
import 'package:qlzbed/qlzb/qlzb/qlzb.dart';
import 'package:qlzbed/service/random_string.dart';
import 'package:quill_delta/quill_delta.dart';

class WriteArticlePage extends StatefulWidget {
  final DocumentSnapshot doc;

  const WriteArticlePage({Key key, @required this.doc}) : super(key: key);
  @override
  _WriteArticlePageState createState() => _WriteArticlePageState();
}

class _WriteArticlePageState extends State<WriteArticlePage> {
  FocusNode focusNode;
  QlzbController _controller;
  @override
  void initState() {
    Delta delta = Delta()..insert('\n');
    final QDocDocument docDocument = QDocDocument.fromDelta(delta);
    _controller = QlzbController(docDocument);
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveDoc();
              },
            )
          ],
          title: Text(AppLocalizations.of(context).writeArticleTitle),
        ),
        body: QlzbScaffold(
          child: QlzbEditor(controller: _controller, focusNode: focusNode),
        ),
      ),
    );
  }

  Future<void> _saveDoc() async {
    final document = _controller.document;
    final jsonData = jsonEncode(document);
    print(jsonData);
    final decoded = jsonDecode(jsonData);
    final sdoc = QDocDocument.fromJson(decoded);
    print(sdoc);
    final bytes = Utf8Encoder().convert(jsonData);
    final fpath = 'articles/' +
        GetIt.I.get<User>().uid +
        '/' +
        Utils.CreateCryptoRandomString();
    // print(decoded);
    try {
      final fstor = FirebaseStorage.instance.ref().child(fpath);
      final ftask = fstor.putData(bytes);
      await ftask.onComplete;
      Navigator.pushNamed(context, '/addArticle',
          arguments: [widget.doc, fpath]);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error),
                  Text(e.toString()),
                  RaisedButton(
                    child: Text(AppLocalizations.of(context).ok),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            );
          });
    }
  }
}