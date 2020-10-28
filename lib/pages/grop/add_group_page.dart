import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:qlzbed/entities/group.dart';
import 'package:qlzbed/entities/moderationGroup.dart';
import 'package:qlzbed/entities/user.dart';
import 'package:qlzbed/localization/localizations.dart';
import 'package:qlzbed/service/fservice.dart';
import 'package:qlzbed/widgets/lang_drop_down_widget.dart';
import 'package:qlzbed/widgets/tags_editor_widget.dart';
import 'package:qlzbed/widgets/titleBloc/title_bloc.dart';
import 'package:qlzbed/widgets/title_editor_widget.dart';

class AddGroupPage extends StatefulWidget {
  final DocumentSnapshot doc;

  const AddGroupPage({Key key, @required this.doc}) : super(key: key);
  @override
  _AddGroupPageState createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  Function onPressed;
  void onlangchange(String nlang) {
    lang = nlang;
    print(lang);
  }

  List<String> tags = List<String>();
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  TextEditingController _titleController;

  String lang;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          actions: [
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
                        return FService.getLang(context);
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
      final mpath = FService.getModerPath(path);
      final docref = Firestore.instance.document(mpath);
      final title = _titleController.text;
      String l = lang;
      if (l == null) {
        l = FService.getLang(context);
      }
      tags.addAll(FService.getTags(title));
      final mpathlast =
          mpath.split('moderation/${FService.getLang(context)}/mainRoutes')[1];
      String humanPath = await FService.getHumanPath(widget.doc.reference);

      print(humanPath);
      print(tags);
      final addgroup = ModerationGroup(
        title: title,
        tags: tags,
        lang: l,
        uid: GetIt.I.get<User>().uid,
        timestamp: Timestamp.now(),
        isModerating: true,
        humanPath: humanPath,
      );
      print(addgroup.toJson());
      final ldocref =
          await docref.collection('moderationList').add(addgroup.toJson());
      final docsnap = await ldocref.get();
      Navigator.pushNamed(context, '/addState', arguments: docsnap);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error),
                  Text(e.toString()),
                  RaisedButton(
                    child: Text(AppLocalizations.of(context).ok),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            );
          });
    }
  }
}
