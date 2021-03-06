import 'package:flutter/material.dart';

import '../entities/dialog.dart';
import '../service/color_extention.dart';
import 'my_image.dart';

class DialogTileWidget extends StatefulWidget {
  final MDialog dialog;

  const DialogTileWidget({Key key, @required this.dialog}) : super(key: key);
  @override
  _DialogTileWidgetState createState() => _DialogTileWidgetState();
}

class _DialogTileWidgetState extends State<DialogTileWidget> {
  MDialog get dialog => widget.dialog;
  @override
  Widget build(BuildContext context) {
    var isLastMessageDialog = false;
    if (dialog.lastMessage.contains(':')) {
      isLastMessageDialog = true;
    }
    return ListTile(
        onTap: () {
          Navigator.pushNamed(context, '/dialogRoom', arguments: dialog);
        },
        onLongPress: () {
          print('Dialog: ' + dialog.toString() + ' selected');
        },
        // contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        title: Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(dialog.name + ' ' + dialog.surname)),
        subtitle: Container(
            height: 50,
            child: isLastMessageDialog
                ? RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      // text: 'Hello ',
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                            text: dialog.lastMessage.split(':')[0] + ': ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: dialog.lastMessage.split(':')[1]),
                      ],
                    ),
                  )
                : Text(
                    dialog.lastMessage,
                    overflow: TextOverflow.ellipsis,
                  )),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: SizedBox(
            // color: Colors.black45,
            width: 40,
            height: 40,
            child: FutureBuilder(
              future:
                  Future.delayed(Duration(milliseconds: 200), () => {'hey': 1}),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                return MyImage(
                  path: dialog.avatar ?? 'avatar.jpg',
                );
              },
            ),
          ),
        ),
        trailing: Container(
          width: 40,
          height: 50,
          child: Column(
            children: [
              dialog.isPinned ? Icon(Icons.push_pin_rounded) : Container(),
              dialog.missedMessages == 0
                  ? Container()
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        color: Colors.white,
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        child: Container(
                          child: Text(
                            dialog.missedMessages.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: HexColor.fromHex('#1D252C'),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ));
  }
}
