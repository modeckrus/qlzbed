import 'package:flutter/material.dart';

import '../entities/moderationState.dart';
import '../service/firebase_service.dart';
import '../service/fservice.dart';

class ModerateSliverListTile extends StatefulWidget {
  ModerateSliverListTile({Key key, @required this.doc}) : super(key: key);
  final DocumentSnapshot doc;
  @override
  _ModerateSliverListTileState createState() => _ModerateSliverListTileState();
}

class _ModerateSliverListTileState extends State<ModerateSliverListTile> {
  @override
  Widget build(BuildContext context) {
    var state = ModerationState.fromJson(widget.doc.data);
    Widget icon = FService.getIconByRoute(state.route);
    String route = FService.getModerationRoute(state.route);

    bool isModerating = state.isModerating;
    if (isModerating == null) {
      isModerating = true;
    }

    return GestureDetector(
      onTap: () async {
        print('tapped');
        if (!isModerating && route == '/list' || route == '/moderateList') {
          Navigator.pushNamed(context, '/specmoderateList',
              arguments: widget.doc);
        } else {
          Navigator.pushNamed(context, isModerating ? route : state.route,
              arguments: widget.doc);
        }
      },
      child: Container(
        height: 80,
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            color: Colors.black38,
            child: ListTile(
              leading: icon,
              title: Text(
                widget.doc.data['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              trailing: Icon(isModerating ? Icons.public_off : Icons.public),
            ),
          ),
        ),
      ),
    );
  }
}
