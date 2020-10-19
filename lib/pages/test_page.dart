import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qlzbed/entities/message.dart';
import 'package:qlzbed/widgets/my_image.dart';

import '../widgets/tags_editor_widget.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  TextEditingController _textEditingController;
  List<String> tags;
  @override
  void initState() {
    _textEditingController = TextEditingController();
    tags = List<String>();

    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 400,
            height: 400,
            child: MyImage(path: 'avatar.gif'),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: RaisedButton(
                  child: Text('Delete all'),
                  onPressed: () {
                    Firestore.instance
                        .collection('user')
                        .snapshots()
                        .listen((event) {
                      event.documents.forEach((element) async {
                        final docs = await Firestore.instance
                            .document(element.reference.path)
                            .collection('subscribers')
                            .getDocuments();
                        docs.documents.forEach((element) {
                          element.reference.delete().then((value) {
                            print('element deleted' + element.data.toString());
                          });
                        });
                        element.reference.delete().then((value) {
                          print('element deleted' + element.data.toString());
                        });
                      });
                    });
                  })),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: RaisedButton(
              child: Text('Get time stamp'),
              onPressed: () async {
                final docsref = await Firestore.instance
                    .collection('test')
                    .document('testTimestamp');

                docsref.setData(
                    Message(timestamp: Timestamp.now(), chatId: 'testId')
                        .toJson());
                final Message message =
                    Message.fromJson((await docsref.get()).data);
                print(message.toString());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: TagsEditor(
              onAddTag: (tag) {
                tags.add(tag);
              },
              onRemoveTag: (tag) {
                tags.remove(tag);
              },
            ),
          ),
        ],
      ),
    ));
  }
}
