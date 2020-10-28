import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qlzbed/entities/moderationArticle.dart';
import 'package:qlzbed/entities/moderationState.dart';
import 'package:qlzbed/localization/localizations.dart';
import 'package:qlzbed/service/fservice.dart';
import 'package:qlzbed/widgets/firestore_animated_list.dart';
import 'package:qlzbed/widgets/moderate_library_widget.dart';

import '../my_icons.dart';

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
                  Widget icon = MyIcons.article;
                  String route = '/';
                  if (state.route == '/article') {
                    icon = MyIcons.article;
                    route = '/moderateArticle';
                  }
                  if (state.route == '/testText') {
                    icon = MyIcons.textTest;
                    route = '/moderateTestText';
                  }
                  if (state.route == '/checkTest') {
                    icon = MyIcons.checkTest;
                    route = '/moderateCheckTest';
                  }
                  if (state.route == '/list') {
                    icon = MyIcons.group;
                    route = '/moderateList';
                  }
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
