import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../entities/moderationState.dart';
import '../localization/localizations.dart';
import '../my_icons.dart';
import '../service/fservice.dart';
import '../widgets/firestore_animated_list.dart';
import '../widgets/moderate_library_widget.dart';

class ModeratePage extends StatefulWidget {
  @override
  _ModeratePageState createState() => _ModeratePageState();
}

class _ModeratePageState extends State<ModeratePage> {
  bool viewMode = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              MyIcons.moderation,
              Text(AppLocalizations.of(context).moderationTitle),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
            IconButton(
              icon: Icon(viewMode ? Icons.table_rows : Icons.lightbulb),
              onPressed: () {
                setState(() {
                  viewMode = !viewMode;
                });
              },
            )
          ],
        ),
        body: viewMode
            ? FirestoreAnimatedList(
                query: Firestore.instance
                    .collectionGroup('moderationList')
                    .where('lang', isEqualTo: FService.getLang(context))
                    .where('isModerating', isEqualTo: true)
                    .orderBy('timestamp'),
                itemBuilder: (context, snapshot, animation, index) {
                  final state = ModerationState.fromJson(snapshot.data);
                  Widget icon = FService.getIconByRoute(state.route);
                  String route = FService.getModerationRoute(state.route);

                  return ListTile(
                    onLongPress: () {
                      Clipboard.setData(
                          ClipboardData(text: snapshot.reference.path));
                      print('copyed');
                      print(snapshot.reference.path);
                    },
                    leading: icon,
                    title: Text(
                      state.title,
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(state.humanPath ?? snapshot.reference.path),
                    trailing: MyIcons.nextRoute,
                    onTap: () {
                      Navigator.pushNamed(context, route, arguments: snapshot);
                    },
                  );
                },
              )
            : ModerateLibraryWidget(),
      ),
    );
  }
}
