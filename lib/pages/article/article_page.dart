import 'dart:convert';

import '../../entities/timestamp.dart';
import 'package:flutter/material.dart';
import '../../service/firebase_service.dart';
import 'package:quill_delta/quill_delta.dart';

import '../../entities/article.dart';
import '../../qlzb/qlzb/qlzb.dart';
import '../../service/fstore_cahe_manager.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';

class ArticlePage extends StatefulWidget {
  final DocumentSnapshot doc;

  const ArticlePage({Key key, @required this.doc}) : super(key: key);
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  QlzbController _controller;
  FocusNode focusNode;
  @override
  void initState() {
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
        appBar: AppBar(),
        body: FutureBuilder(
            future: _loadDocument(),
            builder: (context, snapshot) {
              // return Container();
              if (!snapshot.hasData) {
                return LoadingWidget();
              }
              if (snapshot.hasError) {
                return FErrorWidget(
                  error: snapshot.error,
                );
              }
              return QlzbView(document: snapshot.data);
            }),
      ),
    );
  }

  Future<QDocDocument> _loadDocument() async {
    final article = Article.fromJson(widget.doc.data);
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
}
