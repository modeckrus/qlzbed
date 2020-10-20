import 'package:flutter/material.dart';
import 'dart:js' as js;
// import 'dart:html' as html;

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  TextEditingController _textEditingController;
  List<String> tags;
  String url = "";
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
          RaisedButton(
            child: Text('Js Context'),
            onPressed: () async {
              // js.context.callMethod('testJs', ['huis']);

              js.context['updateImage'] = (dynamic link) {
                print(link);
                setState(() {
                  url = link;
                });
                // print(link as String);
              };
              js.context.callMethod('firestoreTest', ['avatar.jpg']);
            },
          ),
          TestImage(path: 'avatar.jpg'),
          // "https://firebasestorage.googleapis.com/v0/b/education-modeck.appspot.com/o/avatar.jpg?alt=media&token=4fa6ff03-5da0-44c9-bb86-a5e571d502b6"),
        ],
      ),
    ));
  }
}
// children: [
//   Container(
//     width: 400,
//     height: 400,
//     child: MyImage(path: 'avatar.gif'),
//   ),
//   Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//       child: RaisedButton(
//           child: Text('Delete all'),
//           onPressed: () {
//             Firestore.instance
//                 .collection('user')
//                 .snapshots()
//                 .listen((event) {
//               event.documents.forEach((element) async {
//                 final docs = await Firestore.instance
//                     .document(element.reference.path)
//                     .collection('subscribers')
//                     .getDocuments();
//                 docs.documents.forEach((element) {
//                   element.reference.delete().then((value) {
//                     print('element deleted' + element.data.toString());
//                   });
//                 });
//                 element.reference.delete().then((value) {
//                   print('element deleted' + element.data.toString());
//                 });
//               });
//             });
//           })),
//   Padding(
//     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//     child: RaisedButton(
//       child: Text('Get time stamp'),
//       onPressed: () async {
//         final docsref = await Firestore.instance
//             .collection('test')
//             .document('testTimestamp');

//         docsref.setData(
//             Message(timestamp: Timestamp.now(), chatId: 'testId')
//                 .toJson());
//         final Message message =
//             Message.fromJson((await docsref.get()).data);
//         print(message.toString());
//       },
//     ),
//   ),
//   Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//     child: TagsEditor(
//       onAddTag: (tag) {
//         tags.add(tag);
//       },
//       onRemoveTag: (tag) {
//         tags.remove(tag);
//       },
//     ),
//   ),
// ],

class TestImage extends StatefulWidget {
  final String path;

  const TestImage({Key key, @required this.path}) : super(key: key);
  @override
  _TestImageState createState() => _TestImageState();
}

class _TestImageState extends State<TestImage> {
  String url = "";
  @override
  void initState() {
    super.initState();
    final funcname = 'updateImage' + widget.path.split('.')[0];
    print(funcname);
    js.context[funcname] = (surl) {
      setState(() {
        url = surl;
      });
    };
    js.context.callMethod('firestoreTest', [widget.path]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      child: Image.network(url),
    );
  }
}
