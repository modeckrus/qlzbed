import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../entities/dialog.dart';
import '../entities/message.dart';
import '../entities/user.dart';
import '../widgets/firestore_animated_list.dart';
import '../widgets/message_widget.dart';
import '../widgets/my_image.dart';

class DialogPage extends StatefulWidget {
  final MDialog dialog;

  const DialogPage({Key key, this.dialog}) : super(key: key);
  @override
  _DialogPageState createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  MDialog get dialog => widget.dialog;
  TextEditingController _controller;
  ScrollController scrollController;
  @override
  void initState() {
    _controller = TextEditingController();
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset <=
              scrollController.position.minScrollExtent &&
          !scrollController.position.outOfRange) {
        print('reach bottom');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                    width: 40,
                    height: 40,
                    child: MyImage(path: dialog.avatar ?? 'avatar.jpg')),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Container(
                    child: Text(
                  dialog.name ?? '' + ' ' + dialog.surname,
                  overflow: TextOverflow.ellipsis,
                )),
              ),
            ],
          ),
          actions: [
            IconButton(icon: Icon(Icons.call), onPressed: null),
            IconButton(icon: Icon(Icons.more_horiz), onPressed: null),
            IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                })
          ],
        ),
        body: Column(children: [
          Expanded(
            child: FirestoreAnimatedList(
                reverse: true,
                controller: scrollController,
                onDataLoaded: (List<DocumentSnapshot> list) {
                  print('onDataLoaded');
                  Firestore.instance
                      .collection('user')
                      .document(GetIt.I.get<FirebaseUser>().uid)
                      .collection('dialogs')
                      .document(dialog.uid)
                      .updateData({'missedMessages': 0});
                },
                query: Firestore.instance
                    .collection('chats')
                    .document(widget.dialog.uid)
                    .collection('messages')
                    .orderBy('timestamp', descending: true),
                itemBuilder: (context, snapshot, animation, index) {
                  // print(snapshot.data);
                  // print(snapshot.data['timestamp'] as Timestamp);
                  final message = Message.fromJson(snapshot.data);
                  // print('Itembuilder of message ' + message.toString());
                  return SizeTransition(
                    sizeFactor: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    ),
                    axisAlignment: 0.0,
                    child: _buildMessage(message, snapshot),
                  );
                  // return Text(message.message);
                  // return MessageWidget(
                  //   message: message,
                  // );
                  // return SlideTransition(
                  //   position: Tween<Offset>(
                  //     begin: Offset.zero,
                  //     end: const Offset(1.0, 1.0),
                  //   ).animate(animation),
                  //   child: MessageWidget(
                  //     message: message,
                  //   ),
                  // );
                  // return Container();
                }),
          ),
          Container(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: _controller,
                )),
                IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      final User user = GetIt.I.get<User>();
                      final dialogsnap = Firestore.instance
                          .collection('chats')
                          .document(widget.dialog.uid);
                      dialogsnap.collection('messages').add(Message(
                              timestamp: Timestamp.now(),
                              readed: false,
                              chatId: widget.dialog.uid,
                              from: user,
                              message: _controller.text)
                          .toJson());
                      // Firestore.instance
                      //     .collection('chats')
                      //     .document(widget.dialog.uid)
                      //     .updateData({
                      //   'lastMessage':
                      //       GetIt.I.get<User>().name + ' ' + _controller.text,
                      //   'missedMessages': FieldValue.increment(1)
                      // });
                      //final l = MDialog(name: null, surname: null, avatar: null, lastMessage: null, uid: null, isPinned: null, missedMessages: null)
                    }),
              ],
            ),
          )
          // TextFormField(),
        ]),
      ),
    );
  }

  Widget _buildMessage(Message message, DocumentSnapshot docsnap) {
    if (message.from.uid != GetIt.I.get<FirebaseUser>().uid) {
      docsnap.reference.updateData({'readed': true});
    }
    return MessageWidget(
      message: message,
    );
    // return Text(message.message);
  }
}

//0jlZ1P7BCDYVoSBJ466mIuNJKp22
//UiRGU5JFshRn4L3Zql46JKA45682
