import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jiffy/jiffy.dart';

import '../entities/message.dart';
import '../entities/user.dart';
import 'my_image.dart';

class MessageWidget extends StatefulWidget {
  final Message message;

  const MessageWidget({Key key, this.message}) : super(key: key);
  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    bool isMine = true;
    isMine = GetIt.I.get<User>().uid == widget.message.from.uid;
    bool readed = false;
    if (widget.message.readed != null) {
      readed = widget.message.readed;
    }
    final jiff = Jiffy(widget.message.timestamp);
    return ListTile(
      // isThreeLine: true,
      leading: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        child: Container(
          width: 40,
          height: 40,
          child: MyImage(
            path: 'avatar.jpg',
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(widget.message.from.name + ' ' + widget.message.from.surname,
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontSize: 14,
                        color: Colors.cyan,
                      )),
              Spacer(),
              readed ? Icon(Icons.check) : SizedBox(),
            ],
          ),
          Text(
            widget.message.message,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Container(
              child: Text(
            jiff.yMMMMEEEEdjm,
            overflow: TextOverflow.clip,
          )),
        ],
      ),
    );
    return Row(
      children: [
        // MyImage(path: ''),
        Column(
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
                      // isMine ? Spacer() : Container(),
                      Text(jiff.yMMMMEEEEdjm
                          // widget.message.timestamp.toDate().day.toString() +
                          //   ' ' +
                          //   widget.message.timestamp.toDate().month.toString() +
                          //   ' ' +
                          //   widget.message.timestamp.toDate().hour.toString() +
                          //   ':' +
                          //   widget.message.timestamp.toDate().minute.toString(),
                          ),
                      // isMine ? Container() : Spacer(),
                    ],
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
