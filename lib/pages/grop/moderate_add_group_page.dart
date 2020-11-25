import '../../entities/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../service/firebase_service.dart';

import '../../entities/group.dart';
import '../../entities/moderationGroup.dart';
import '../../entities/user.dart';
import '../../localization/localizations.dart';
import '../../service/dialog_sevice.dart';
import '../../service/fservice.dart';
import '../../widgets/lang_drop_down_widget.dart';
import '../../widgets/tags_editor_widget.dart';
import '../../widgets/titleBloc/title_bloc.dart';
import '../../widgets/title_editor_widget.dart';

class ModerateAddGroupPage extends StatefulWidget {
  final DocumentSnapshot doc;

  const ModerateAddGroupPage({Key key, @required this.doc}) : super(key: key);
  @override
  _ModerateAddGroupPageState createState() => _ModerateAddGroupPageState();
}

class _ModerateAddGroupPageState extends State<ModerateAddGroupPage> {
  Function onPressed;
  void onlangchange(String nlang) {
    lang = nlang;
    print(lang);
  }

  ModerationGroup oldGroup;
  List<String> tags = List<String>();
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    oldGroup = ModerationGroup.fromJson(widget.doc.data);
    // article = ModerationArticle.fromJson(widget.doc.data);
    _titleController.text = oldGroup.title;
    lang = oldGroup.lang;
    tags = oldGroup.tags;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  TextEditingController _titleController;
  String get title => _titleController.text;
  String lang;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                DialogService.showLoadingDialog(
                    context, AppLocalizations.of(context).removing, () async {
                  await widget.doc.reference.delete();
                  print('delete complete');
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
          title: Text(AppLocalizations.of(context).titleAddGroup),
        ),
        body: BlocProvider(
          create: (context) =>
              TitleBloc()..add(TitleChanged(_titleController.text)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).path +
                      ': \n' +
                      widget.doc.reference.path,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      AppLocalizations.of(context).langof,
                      style: TextStyle(fontSize: 20),
                    ),
                    LangDropDownButton(
                      onlangchange: onlangchange,
                      onStart: () {
                        if (oldGroup.lang == null) {
                          return FService.getLang(context);
                        } else {
                          return oldGroup.lang;
                        }
                      },
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: TitleEditor(
                      controller: _titleController,
                    )),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: TagsEditor(
                    onAddTag: (tag) {
                      tags.add(tag);
                    },
                    onRemoveTag: (tag) {
                      tags.remove(tag);
                    },
                    onStart: () {
                      return oldGroup.tags;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: BlocBuilder<TitleBloc, TitleState>(
                      builder: (context, state) {
                    if (state is TitleOkS) {
                      return RaisedButton(
                        color: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        onPressed: () {
                          _addGroup();
                        },
                        child: Container(
                          // width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context).titleAddGroup,
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return RaisedButton(
                        color: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        onPressed: null,
                        child: Container(
                          // width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context).titleAddGroup,
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ),
                      );
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addGroup() async {
    try {
      final path = widget.doc.reference.path;

      String l;
      if (lang == null) {
        l = FService.getLang(context);
      } else {
        l = lang;
      }

      final moderateGroup = ModerationGroup(
        title: title,
        tags: tags,
        lang: l,
        uid: oldGroup.uid,
        timestamp: Timestamp.now(),
        isModerating: false,
        humanPath: oldGroup.humanPath,
        moderator: GetIt.I.get<User>().uid,
      );
      final pubGroup = Group(
          lang: l,
          title: title,
          tags: tags,
          uid: oldGroup.uid,
          timestamp: oldGroup.timestamp);
      await widget.doc.reference.setData(moderateGroup.toJson(), merge: true);
      final pubpath = FService.getPubPath(widget.doc.reference.path);
      print(pubpath);
      final pubdocref = FirebaseService.document(pubpath);
      pubdocref.setData(pubGroup.toJson());
      await pubdocref.get();
      Navigator.pushNamed(context, '/moderation');
    } catch (e) {
      DialogService.showErrorDialog(context, e.toString());
    }
  }
}
