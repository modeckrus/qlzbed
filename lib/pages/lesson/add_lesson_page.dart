import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:qlzbed/entities/fstateMinimum.dart';
import 'package:qlzbed/entities/moderationLesson.dart';
import 'package:qlzbed/entities/moderationState.dart';
import 'package:qlzbed/entities/user.dart';
import 'package:qlzbed/localization/localizations.dart';
import 'package:qlzbed/service/dialog_sevice.dart';
import 'package:qlzbed/service/fservice.dart';
import 'package:qlzbed/widgets/add_lesson_widget.dart';
import 'package:qlzbed/widgets/lang_drop_down_widget.dart';
import 'package:qlzbed/widgets/tags_editor_widget.dart';
import 'package:qlzbed/widgets/titleBloc/title_bloc.dart';
import 'package:qlzbed/widgets/title_editor_widget.dart';

class AddLessonPage extends StatefulWidget {
  final DocumentSnapshot doc;

  const AddLessonPage({Key key, @required this.doc}) : super(key: key);
  @override
  _AddLessonPageState createState() => _AddLessonPageState();
}

class _AddLessonPageState extends State<AddLessonPage> {
  Function onPressed;
  List<FStateMinimum> states = List();
  ModerationState moderationState;
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
    moderationState = ModerationState.fromJson(widget.doc.data);
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
          title: Text(AppLocalizations.of(context).titleAddLesson),
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
                moderationState != null
                    ? moderationState.humanPath != null
                        ? Text(
                            AppLocalizations.of(context).humanPath +
                                    ': \n' +
                                    moderationState.humanPath ??
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
                  ),
                ),
                AddLessonWidget(
                    onAddState: onAddState, onRemoveState: onRemoveState),
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
      final addlesson = ModerationLesson(
        title: title,
        tags: tags,
        lang: l,
        uid: GetIt.I.get<User>().uid,
        timestamp: Timestamp.now(),
        isModerating: true,
        humanPath: humanPath,
        states: states,
      );
      print(addlesson.toJson());
      final ldocref =
          await docref.collection('moderationList').add(addlesson.toJson());
      // final docsnap = await ldocref.get();
      // Navigator.pushNamed(context, '/moderationList', arguments: widget.doc);
      Navigator.pushNamed(context, '/moderattion');
    } catch (e) {
      DialogService.showErrorDialog(context, e.toString());
    }
  }
}
