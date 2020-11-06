import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';

import '../entities/fstateMinimum.dart';
import '../qlzb/qlzb/qlzb.dart';
import '../service/fstore_cahe_manager.dart';
import 'error_widget.dart';
import 'loading_widget.dart';

class ArticleWidget extends StatefulWidget {
  final FStateMinimum state;

  const ArticleWidget({Key key, @required this.state}) : super(key: key);
  @override
  _ArticleWidgetState createState() => _ArticleWidgetState();
}

class _ArticleWidgetState extends State<ArticleWidget> {
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
    return Container(
      child: FutureBuilder(
          future: _loadDocument(),
          builder: (context, snapshot) {
            // return Container();
            if (!snapshot.hasData) {
              return SizedBox(width: 100, height: 20, child: LoadingWidget());
            }
            if (snapshot.hasError) {
              return FErrorWidget(
                error: snapshot.error,
              );
            }
            return QlzbView(document: snapshot.data);
          }),
    );
  }

  Future<QDocDocument> _loadDocument() async {
    final Delta delta = Delta()..insert("Something go wrong\n");
    try {
      final file = await FStoreCacheManager().getFStoreFile(widget.state.path);
      if (file != null) {
        if (await file.exists()) {
          final String contents = await file.readAsString();
          if (contents == null || contents == '') {
            return QDocDocument.fromDelta(delta);
          }
          print(contents);
          return QDocDocument.fromJson(jsonDecode(contents));
        }

        return QDocDocument.fromDelta(delta);
      } else {
        return QDocDocument.fromDelta(delta);
      }
    } catch (e) {
      return QDocDocument.fromDelta(delta);
    }
  }
}
