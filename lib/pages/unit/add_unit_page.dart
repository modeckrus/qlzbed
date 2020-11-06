import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../entities/fstateMinimum.dart';
import '../../entities/moderationState.dart';
import '../../entities/moderationUnit.dart';
import '../../entities/user.dart';
import '../../localization/localizations.dart';
import '../../service/dialog_sevice.dart';
import '../../service/fservice.dart';
import '../../widgets/add_unit_widget.dart';
import '../../widgets/lang_drop_down_widget.dart';
import '../../widgets/tags_editor_widget.dart';
import '../../widgets/titleBloc/title_bloc.dart';
import '../../widgets/title_editor_widget.dart';

class AddUnitPage extends StatefulWidget {
  final DocumentSnapshot doc;

  const AddUnitPage({Key key, @required this.doc}) : super(key: key);
  @override
  _AddUnitPageState createState() => _AddUnitPageState();
}

class _AddUnitPageState extends State<AddUnitPage> {
  Function onPressed;
  List<FStateMinimum> lessons = List();
  ModerationState moderationState;
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
          title: Text(AppLocalizations.of(context).titleAddUnit),
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
                AddUnitWidget(
                    onAddLesson: onAddLesson, onRemoveLesson: onRemoveLesson),
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
      final addlesson = ModerationUnit(
        title: title,
        tags: tags,
        lang: l,
        uid: GetIt.I.get<User>().uid,
        timestamp: Timestamp.now(),
        isModerating: true,
        humanPath: humanPath,
        lessons: lessons,
      );
      print(addlesson.toJson());
      final ldocref =
          await docref.collection('moderationList').add(addlesson.toJson());
      // final docsnap = await ldocref.get();
      // Navigator.pushNamed(context, '/moderationList', arguments: widget.doc);
      Navigator.pushNamed(context, '/moderation');
    } catch (e) {
      DialogService.showErrorDialog(context, e.toString());
    }
  }
}
