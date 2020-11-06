import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../entities/fstateMinimum.dart';
import '../../entities/lesson.dart';
import '../../entities/moderationLesson.dart';
import '../../entities/user.dart';
import '../../localization/localizations.dart';
import '../../service/dialog_sevice.dart';
import '../../service/fservice.dart';
import '../../widgets/add_lesson_widget.dart';
import '../../widgets/lang_drop_down_widget.dart';
import '../../widgets/tags_editor_widget.dart';
import '../../widgets/titleBloc/title_bloc.dart';
import '../../widgets/title_editor_widget.dart';

class ModerateAddLessonPage extends StatefulWidget {
  final DocumentSnapshot doc;

  const ModerateAddLessonPage({Key key, @required this.doc}) : super(key: key);
  @override
  _ModerateAddLessonPageState createState() => _ModerateAddLessonPageState();
}

class _ModerateAddLessonPageState extends State<ModerateAddLessonPage> {
  Function onPressed;
  List<FStateMinimum> states = List();
  ModerationLesson moderationLesson;
  void onlangchange(String nlang) {
    lang = nlang;
    print(lang);
  }

  void onAddState(FStateMinimum state) {
    states.add(state);
  }

  void onRemoveState(FStateMinimum state) {
    states.remove(state);
  }

  List<String> tags = List<String>();
  @override
  void initState() {
    super.initState();
    moderationLesson = ModerationLesson.fromJson(widget.doc.data);
    _titleController = TextEditingController();
    _titleController.text = moderationLesson.title;
    tags = moderationLesson.tags;
    lang = moderationLesson.lang;
    states = moderationLesson.states;
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
          title: Text(AppLocalizations.of(context).titleModerateAddLesson),
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
                moderationLesson != null
                    ? moderationLesson.humanPath != null
                        ? Text(
                            AppLocalizations.of(context).humanPath +
                                    ': \n' +
                                    moderationLesson.humanPath ??
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
                AddLessonWidget(
                  onAddState: onAddState,
                  onRemoveState: onRemoveState,
                  onStart: () {
                    return states;
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
                          _addLesson();
                        },
                        child: Container(
                          // width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context).titleAddLesson,
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
                            AppLocalizations.of(context).titleAddLesson,
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

  Future<void> _addLesson() async {
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
      final mlesson = ModerationLesson(
        title: title,
        tags: tags,
        lang: l,
        uid: moderationLesson.uid,
        timestamp: Timestamp.now(),
        isModerating: false,
        humanPath: humanPath,
        states: states,
        moderator: GetIt.I.get<User>().uid,
      );
      print(mlesson.toJson());
      await widget.doc.reference.setData(mlesson.toJson());
      final publesson = Lesson(
          lang: mlesson.lang,
          title: mlesson.title,
          tags: mlesson.tags,
          uid: mlesson.uid,
          timestamp: Timestamp.now(),
          states: mlesson.states);
      docref.setData(publesson.toJson());
      // final docsnap = await ldocref.get();
      // Navigator.pushNamed(context, '/moderationList', arguments: widget.doc);
      Navigator.pushNamed(context, '/moderation');
    } catch (e) {
      DialogService.showErrorDialog(context, e.toString());
    }
  }
}
