import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qlzbed/localization/localizations.dart';
import 'package:qlzbed/qlzb/qlzb/qlzb.dart';
import 'package:qlzbed/qlzb/qlzb/src/widgets/scaffold.dart';
import 'package:quill_delta/quill_delta.dart';
// import 'dart:js' as js;
// import 'dart:html' as html;

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  QlzbController _controller;
  FocusNode focusNode;
  QDocDocument doc;
  @override
  void initState() {
    final Delta delta = Delta()..insert('hey\n')..insert("""
    ef
    fe
    few
    few
    f

    f
    wf
    we
    fe
    f
    fw
    f
    we
    f
    ewf
    ew
    f
    ewf
    we
    fw
    f
    e
    few
    fe
    few
    fe
    fwe
    fe
    few
    f
    ew
    few
    ewf
    efw
    efw
    efw
    ef
    efw
    efw
    ewf
    efw
    ewf
    fwe

    \n""");
    doc = QDocDocument.fromDelta(delta);
    doc.format(0, 2, QDocAttribute.color2);
    doc.format(2, 3, QDocAttribute.miss.fromString(['Hey']));
    doc.format(0, 3, QDocAttribute.link.fromString('https://google.com'));
    print(doc.toJson());
    _controller = QlzbController(doc);
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
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                'hey',
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.history_edu),
              onPressed: () {
                print(_controller.document.toJson());
                // final docref = Firestore.instance.collection(path)
              },
            ),
            body: Column(
              children: [
                // Expanded(
                //   child:
                //       QlzbEditor(controller: _controller, focusNode: focusNode),
                // ),
                Expanded(
                  child: SingleChildScrollView(
                    child: QlzbView(
                      document: doc,
                    ),
                  ),
                ),
                ListTile(
                  title: Text('clear all'),
                  onLongPress: () async {
                    print('onLong press');

                    final documents = await Firestore.instance
                        .collection(
                            '/moderation/en/mainRoutes/1s0Bsu0MiikLdK5jK61c/moderationList')
                        .getDocuments();
                    documents.documents.forEach((element) {
                      print(element.data);
                      element.reference.delete();
                    });
                  },
                )
              ],
            )));
  }
}
