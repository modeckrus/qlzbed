import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../entities/article.dart';
import '../../entities/moderationArticle.dart';
import '../../entities/user.dart';
import '../../localization/localizations.dart';
import '../../my_icons.dart';
import '../../service/dialog_sevice.dart';
import '../../service/fservice.dart';
import '../../widgets/lang_drop_down_widget.dart';
import '../../widgets/tags_editor_widget.dart';
import '../../widgets/titleBloc/title_bloc.dart';
import '../../widgets/title_editor_widget.dart';

class ModerateAddArticlePage extends StatefulWidget {
  final DocumentSnapshot doc;
  final String filepath;
  const ModerateAddArticlePage(
      {Key key, @required this.doc, @required this.filepath})
      : super(key: key);
  @override
  _ModerateAddArticlePageState createState() => _ModerateAddArticlePageState();
}

class _ModerateAddArticlePageState extends State<ModerateAddArticlePage> {
  Function onPressed;
  ModerationArticle article;
  void onlangchange(String nlang) {
    lang = nlang;
    print(lang);
  }

  List<String> tags = List<String>();
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    article = ModerationArticle.fromJson(widget.doc.data);
    _titleController.text = article.title;
    lang = article.lang;
    tags = article.tags;
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
              icon: Icon(Icons.remove),
              onPressed: () {
                DialogService.showLoadingDialog(
                    context, AppLocalizations.of(context).removing, () async {
                  await FirebaseStorage.instance
                      .ref()
                      .child(article.path)
                      .delete();

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
          title: Row(
            children: [
              MyIcons.moderation,
              Text(AppLocalizations.of(context).titleModerateAddArticle),
            ],
          ),
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
                    fontSize: 16,
                  ),
                ),
                Divider(),
                Text(
                  AppLocalizations.of(context).storagePath +
                      ': ' +
                      widget.filepath,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Divider(),
                Text(
                  AppLocalizations.of(context).humanPath +
                      ': ' +
                      article.humanPath,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
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
                        if (article.lang == null) {
                          return FService.getLang(context);
                        } else {
                          return article.lang;
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
                      return tags;
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
                          _addArticle();
                        },
                        child: Container(
                          // width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context).titleAddArticle,
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
                            AppLocalizations.of(context).titleAddArticle,
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

  Future<void> _addArticle() async {
    try {
      final title = _titleController.text;
      String l = lang;
      if (l == null) {
        l = FService.getLang(context);
      }
      tags.addAll(FService.getTags(title));
      // final humanPath = await FService.getHumanPath(widget.doc.reference);
      final narticle = ModerationArticle(
        path: widget.filepath,
        uid: article.uid,
        tags: tags,
        lang: l,
        title: title,
        timestamp: Timestamp.now(),
        humanPath: article.humanPath,
        isModerating: false,
        moderator: GetIt.I.get<User>().uid,
      );
      print(narticle.toJson());
      widget.doc.reference.setData(narticle.toJson(), merge: true);
      final pubarticle = Article(
          path: narticle.path,
          uid: narticle.uid,
          tags: narticle.tags,
          title: narticle.title,
          timestamp: article.timestamp,
          lang: narticle.lang);
      final pubpath = FService.getPubPath(widget.doc.reference.path);
      print(pubpath);
      final pubdocref = Firestore.instance.document(pubpath);
      pubdocref.setData(pubarticle.toJson());
      final pubdocsnap = await pubdocref.get();
      Navigator.pushNamed(context, '/article', arguments: pubdocsnap);
    } catch (e) {
      DialogService.showErrorDialog(context, e.toString());
    }
  }
}
