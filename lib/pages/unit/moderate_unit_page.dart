import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:qlzbed/entities/fstateMinimum.dart';
import 'package:qlzbed/entities/lesson.dart';
import 'package:qlzbed/entities/moderationUnit.dart';
import 'package:qlzbed/entities/moderationState.dart';
import 'package:qlzbed/entities/unit.dart';
import 'package:qlzbed/entities/user.dart';
import 'package:qlzbed/localization/localizations.dart';
import 'package:qlzbed/service/dialog_sevice.dart';
import 'package:qlzbed/service/fservice.dart';
import 'package:qlzbed/widgets/add_lesson_widget.dart';
import 'package:qlzbed/widgets/add_unit_widget.dart';
import 'package:qlzbed/widgets/lang_drop_down_widget.dart';
import 'package:qlzbed/widgets/tags_editor_widget.dart';
import 'package:qlzbed/widgets/titleBloc/title_bloc.dart';
import 'package:qlzbed/widgets/title_editor_widget.dart';

class ModerateAddUnitPage extends StatefulWidget {
  final DocumentSnapshot doc;

  const ModerateAddUnitPage({Key key, @required this.doc}) : super(key: key);
  @override
  _ModerateAddUnitPageState createState() => _ModerateAddUnitPageState();
}

class _ModerateAddUnitPageState extends State<ModerateAddUnitPage> {
  Function onPressed;
  List<FStateMinimum> lessons = List();
  ModerationUnit moderationUnit;
  void onlangchange(String nlang) {
    lang = nlang;
    print(lang);
  }

  void onAddLesson(FStateMinimum lesson) {
    lessons.add(lesson);
  }

  void onRemoveLesson(FStateMinimum lesson) {
    lessons.remove(lesson);
  }

  List<String> tags = List<String>();
  @override
  void initState() {
    super.initState();
    moderationUnit = ModerationUnit.fromJson(widget.doc.data);
    _titleController = TextEditingController();
    _titleController.text = moderationUnit.title;
    tags = moderationUnit.tags;
    lang = moderationUnit.lang;
    lessons = moderationUnit.lessons;
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
          title: Text(AppLocalizations.of(context).titleModerateAddUnit),
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
                    fontSize: 20,
                  ),
                ),
                moderationUnit != null
                    ? moderationUnit.humanPath != null
                        ? Text(
                            AppLocalizations.of(context).humanPath +
                                    ': \n' +
                                    moderationUnit.humanPath ??
                                '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )
                        : Container()
                    : Container(),
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
                    onStart: () {
                      return tags;
                    },
                  ),
                ),
                AddUnitWidget(
                  onAddLesson: onAddLesson,
                  onRemoveLesson: onRemoveLesson,
                  onStart: () {
                    return lessons;
                  },
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
                          _addUnit();
                        },
                        child: Container(
                          // width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context).titleAddUnit,
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
                            AppLocalizations.of(context).titleAddUnit,
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

  Future<void> _addUnit() async {
    try {
      final path = widget.doc.reference.path;
      final pubpath = FService.getPubPath(path);
      final docref = Firestore.instance.document(pubpath);
      final title = _titleController.text;
      String l = lang;
      if (l == null) {
        l = FService.getLang(context);
      }
      tags.addAll(FService.getTags(title));
      String humanPath = await FService.getHumanPath(widget.doc.reference);

      print(humanPath);
      print(tags);
      final mlesson = ModerationUnit(
        title: title,
        tags: tags,
        lang: l,
        uid: moderationUnit.uid,
        timestamp: Timestamp.now(),
        isModerating: false,
        humanPath: humanPath,
        lessons: lessons,
        moderator: GetIt.I.get<User>().uid,
      );
      print(mlesson.toJson());
      await widget.doc.reference.setData(mlesson.toJson());
      final publesson = Unit(
          lang: mlesson.lang,
          title: mlesson.title,
          tags: mlesson.tags,
          uid: mlesson.uid,
          timestamp: Timestamp.now(),
          lessons: mlesson.lessons);
      docref.setData(publesson.toJson());
      // final docsnap = await ldocref.get();
      // Navigator.pushNamed(context, '/moderationList', arguments: widget.doc);
      Navigator.pushNamed(context, '/moderation');
    } catch (e) {
      DialogService.showErrorDialog(context, e.toString());
    }
  }
}
