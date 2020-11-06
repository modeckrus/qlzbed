import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../entities/moderationCurriculum.dart';
import '../../localization/localizations.dart';
import '../../service/dialog_sevice.dart';
import '../../service/fservice.dart';
import '../../widgets/lang_drop_down_widget.dart';
import '../../widgets/tags_editor_widget.dart';
import '../../widgets/titleBloc/title_bloc.dart';
import '../../widgets/title_editor_widget.dart';

class AddCurriculumPage extends StatefulWidget {
  final DocumentSnapshot doc;
  final String learnPath;
  final String descPath;
  const AddCurriculumPage(
      {Key key,
      @required this.doc,
      @required this.learnPath,
      @required this.descPath})
      : super(key: key);
  @override
  _AddCurriculumPageState createState() => _AddCurriculumPageState();
}

class _AddCurriculumPageState extends State<AddCurriculumPage> {
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
          title: Text(AppLocalizations.of(context).titleAddCurriculum),
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
                      ': ' +
                      widget.doc.reference.path,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Divider(),
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
                          _addCurriculum();
                        },
                        child: Container(
                          // width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context).titleAddCurriculum,
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
                            AppLocalizations.of(context).titleAddCurriculum,
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

  Future<void> _addCurriculum() async {
    try {
      final path = widget.doc.reference.path;
      final mpath = FService.getModerPath(path);
      final mdocref = Firestore.instance.document(mpath);
      final title = _titleController.text;
      String l = lang;
      if (l == null) {
        l = FService.getLang(context);
      }
      tags.addAll(FService.getTags(title));
      // final moderationPath = FService.getModerPath(path);
      final humanPath = await FService.getHumanPath(widget.doc.reference);
      // final article = ModerationCurriculum(
      //   descPath: widget.descPath,
      //   uid: GetIt.I.get<User>().uid,
      //   tags: tags,
      //   lang: l,
      //   title: title,
      //   timestamp: Timestamp.now(),
      //   humanPath: humanPath,
      //   isModerating: true,
      // );
      final ModerationCurriculum curriculum = null;
      print(curriculum.toJson());
      print(mpath);
      final ldocref =
          await mdocref.collection('moderationList').add(curriculum.toJson());
      final ldocsnap = await ldocref.get();
      Navigator.pushNamed(context, '/curriculum', arguments: ldocsnap);
    } catch (e) {
      DialogService.showErrorDialog(context, e.toString());
    }
  }
}