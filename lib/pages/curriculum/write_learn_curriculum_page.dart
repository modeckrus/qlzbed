import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:quill_delta/quill_delta.dart';

import '../../entities/user.dart';
import '../../localization/localizations.dart';
import '../../qlzb/qlzb/qlzb.dart';
import '../../service/dialog_sevice.dart';
import '../../service/random_string.dart';

class WriteCurriculumPage extends StatefulWidget {
  final DocumentSnapshot doc;

  const WriteCurriculumPage({Key key, @required this.doc}) : super(key: key);
  @override
  _WriteCurriculumPageState createState() => _WriteCurriculumPageState();
}

class _WriteCurriculumPageState extends State<WriteCurriculumPage> {
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
          title: Text(AppLocalizations.of(context).writeCurriculumTitle),
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
      Navigator.pushNamed(context, '/addCurriculum',
          arguments: [widget.doc, fpath]);
    } catch (e) {
      DialogService.showErrorDialog(context, e.toString());
    }
  }
}
