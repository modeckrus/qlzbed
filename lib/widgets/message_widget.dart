import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../entities/message.dart';

class MessageWidget extends StatefulWidget {
  final Message message;

  const MessageWidget({Key key, this.message}) : super(key: key);
  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    final bool isMine = true;
    // GetIt.I.get<FirebaseUser>().uid == widget.message.from.uid;
    final jiff = Jiffy(widget.message.timestamp.toDate());
    return Column(
      children: [
        Divider(),
        Container(
          child: ListTile(
              tileColor: Theme.of(context).bottomAppBarColor,
              title: Row(
                children: [
                  // isMine ? Container() : Spacer(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.message.from.name +
                            ' ' +
                            widget.message.from.surname),
                        Container(
                          // width: double.infinity,

                          child: Text(
                            widget.message.message,
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 40),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // isMine ? Spacer() : Container(),
                ],
              ),
              subtitle: Row(
                children: [
                  isMine ? Spacer() : Container(),
                  Text(jiff.yMMMMEEEEdjm
                      // widget.message.timestamp.toDate().day.toString() +
                      //   ' ' +
                      //   widget.message.timestamp.toDate().month.toString() +
                      //   ' ' +
                      //   widget.message.timestamp.toDate().hour.toString() +
                      //   ':' +
                      //   widget.message.timestamp.toDate().minute.toString(),
                      ),
                  isMine ? Container() : Spacer(),
                ],
              )),
        ),
      ],
    );
  }
}
