import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';

import '../../localization/localizations.dart';
import '../../qlzb/qlzb/qlzb.dart';
import '../../service/dialog_sevice.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';

class WriteCurriculumDescPage extends StatefulWidget {
  // final DocumentSnapshot doc;
  // final String learnPath;
  final String descPath;
  const WriteCurriculumDescPage({
    Key key,
    //  @required this.doc, @required this.learnPath
    @required this.descPath,
  }) : super(key: key);
  @override
  _WriteCurriculumDescPageState createState() =>
      _WriteCurriculumDescPageState();
}

class _WriteCurriculumDescPageState extends State<WriteCurriculumDescPage> {
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
          title: Text(
            AppLocalizations.of(context).writeCurriculumDescTitle,
            softWrap: true,
            overflow: TextOverflow.fade,
          ),
        ),
        body: FutureBuilder(
          future: _loadDocument(),
          builder: (context, snap) {
            if (snap.hasError) {
              return FErrorWidget(
                error: snap.error,
              );
            }
            if (!snap.hasData) {
              return LoadingWidget();
            }
            _controller = QlzbController(snap.data);
            return QlzbScaffold(
              child: QlzbEditor(controller: _controller, focusNode: focusNode),
            );
          },
        ),
      ),
    );
  }

  Future<QDocDocument> _loadDocument() async {
    final Delta delta = Delta()..insert("Something go wrong\n");
    try {
      final contents = await FirebaseStorage.instance
          .ref()
          .child(widget.descPath)
          .getData(50 * 1024 * 1024);
      if (contents == null) {
        return QDocDocument.fromDelta(delta);
      } // If ok
      else {
        return QDocDocument.fromJson(jsonDecode(utf8.decode(contents)));
      }
    } catch (e) {
      return QDocDocument.fromDelta(delta);
    }
  }

  Future<void> _saveDoc() async {
    final document = _controller.document;
    final jsonData = jsonEncode(document);
    print(jsonData);
    final decoded = jsonDecode(jsonData);
    final sdoc = QDocDocument.fromJson(decoded);
    print(sdoc);
    final bytes = Utf8Encoder().convert(jsonData);
    // final fpath = 'curriculumDesc/' +
    //     GetIt.I.get<User>().uid +
    //     '/' +
    //     Utils.CreateCryptoRandomString();
    // print(decoded);
    try {
      final fstor = FirebaseStorage.instance.ref().child(widget.descPath);
      final ftask = fstor.putData(bytes);
      await ftask.onComplete;

      Navigator.pop(context);
      // Navigator.pushNamed(context, '/addCurriculum', arguments: [
      //   widget.doc,
      //   widget.learnPath,
      //   fpath,
      // ]);
    } catch (e) {
      DialogService.showErrorDialog(context, e.toString());
    }
  }
}
