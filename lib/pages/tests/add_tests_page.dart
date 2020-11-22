import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../entities/moderationTests.dart';
import '../../entities/test_base.dart';
import '../../entities/user.dart';
import '../../localization/localizations.dart';
import '../../service/dialog_sevice.dart';
import '../../service/fservice.dart';
import '../../widgets/lang_drop_down_widget.dart';
import '../../widgets/tags_editor_widget.dart';
import '../../widgets/titleBloc/title_bloc.dart';
import '../../widgets/title_editor_widget.dart';

class AddTestsPage extends StatefulWidget {
  final DocumentSnapshot doc;
  final String filepath;
  final List<TestBase> tests;
  const AddTestsPage(
      {Key key,
      @required this.doc,
      @required this.filepath,
      @required this.tests})
      : super(key: key);
  @override
  _AddTestsPageState createState() => _AddTestsPageState();
}

class _AddTestsPageState extends State<AddTestsPage> {
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
          title: Text(AppLocalizations.of(context).titleAddTests),
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
                Text(
                  AppLocalizations.of(context).storagePath +
                      ': ' +
                      widget.filepath,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
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
                          _addTests();
                        },
                        child: Container(
                          // width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context).titleAddTests,
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
                            AppLocalizations.of(context).titleAddTests,
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

  Future<void> _addTests() async {
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
      final article = ModerationTests(
        path: widget.filepath,
        uid: GetIt.I.get<User>().uid,
        tags: tags,
        lang: l,
        title: title,
        timestamp: Timestamp.now(),
        humanPath: humanPath,
        isModerating: true,
        tests: widget.tests,
      );
      print(article.toJson());
      print(mpath);
      final ldocref =
          await mdocref.collection('moderationList').add(article.toJson());
      final ldocsnap = await ldocref.get();
      Navigator.pushNamed(context, '/article', arguments: ldocsnap);
    } catch (e) {
      DialogService.showErrorDialog(context, e.toString());
    }
  }
}
