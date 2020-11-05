import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qlzbed/entities/moderationArticle.dart';
import 'package:qlzbed/entities/user.dart';
import 'package:qlzbed/localization/localizations.dart';
import 'package:qlzbed/qlzb/qlzb/qlzb.dart';
import 'package:qlzbed/service/dialog_sevice.dart';
import 'package:qlzbed/service/fstore_cahe_manager.dart';
import 'package:qlzbed/service/random_string.dart';
import 'package:qlzbed/widgets/error_widget.dart';
import 'package:qlzbed/widgets/loading_widget.dart';
import 'package:quill_delta/quill_delta.dart';

class ModerateArticlePage extends StatefulWidget {
  final DocumentSnapshot doc;

  const ModerateArticlePage({Key key, @required this.doc}) : super(key: key);
  @override
  _ModerateArticlePageState createState() => _ModerateArticlePageState();
}

class _ModerateArticlePageState extends State<ModerateArticlePage> {
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
    if (_controller != null) {
      _controller.dispose();
    }

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
          title: Text(AppLocalizations.of(context).moderateArticleTitle),
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
            _controller = QlzbController(snapshot.data);
            return QlzbScaffold(
              child: QlzbEditor(controller: _controller, focusNode: focusNode),
            );
          },
        ),
      ),
    );
  }

  Future<QDocDocument> _loadDocument() async {
    final article = ModerationArticle.fromJson(widget.doc.data);
    final Delta delta = Delta()..insert("Something go wrong\n");
    final file = await FStoreCacheManager().getFStoreFile(article.path);

    if (await file.exists()) {
      final String contents = await file.readAsString();
      if (contents == null || contents == '') {
        return QDocDocument.fromDelta(delta);
      }
      print(contents);
      return QDocDocument.fromJson(jsonDecode(contents));
    }

    return QDocDocument.fromDelta(delta);
  }

  Future<void> _saveDoc() async {
    //TODO: save doc for moderation
    final document = _controller.document;
    final jsonData = jsonEncode(document);
    print(jsonData);
    final decoded = jsonDecode(jsonData);
    final sdoc = QDocDocument.fromJson(decoded);
    print(sdoc);
    final bytes = Utf8Encoder().convert(jsonData);
    final fpath = widget.doc.data['path'];
    FStoreCacheManager().removeFile(fpath).then((value) {
      print('$fpath ; removed from cache');
    });
    // print(decoded);
    try {
      final fstor = FirebaseStorage.instance.ref().child(fpath);
      final ftask = fstor.putData(bytes);
      await ftask.onComplete;
      Navigator.pushNamed(context, '/moderateAddArticle',
          arguments: [widget.doc, fpath]);
    } catch (e) {
      DialogService.showErrorDialog(context, e.toString());
    }
  }
}
