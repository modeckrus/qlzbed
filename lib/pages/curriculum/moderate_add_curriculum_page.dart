import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:qlzbed/widgets/error_widget.dart';
import 'package:qlzbed/widgets/loading_widget.dart';

import '../../entities/base_curriculum.dart';
import '../../entities/curriculum.dart';
import '../../entities/fstateMinimum.dart';
import '../../entities/moderate_base_curriculum.dart';
import '../../entities/moderationCurriculum.dart';
import '../../entities/user.dart';
import '../../localization/localizations.dart';
import '../../service/dialog_sevice.dart';
import '../../service/fservice.dart';
import '../../service/random_string.dart';
import '../../widgets/how_much_time_widget.dart';
import '../../widgets/lang_drop_down_widget.dart';
import '../../widgets/tags_editor_widget.dart';
import 'bloc/curriculum_bloc.dart';
import 'descprition_widget.dart';
import 'lessons_picker_widget.dart';
import 'title_curriculum_widget.dart';
import 'what_to_learn_widget.dart';
import 'write_short_desc_widget.dart';

class ModerateAddCurriculumPage extends StatefulWidget {
  final DocumentSnapshot doc;
  // final String learnPath;
  // final String descPath;
  const ModerateAddCurriculumPage({
    Key key,
    @required this.doc,
    // @required this.learnPath,
    // @required this.descPath,
  }) : super(key: key);
  @override
  _ModerateAddCurriculumPageState createState() =>
      _ModerateAddCurriculumPageState();
}

class _ModerateAddCurriculumPageState extends State<ModerateAddCurriculumPage> {
  Function onPressed;
  //Controllers
  TextEditingController _titleController;
  TextEditingController _shortDescController;
  //Lists
  List<String> learn = List();
  List<String> requirements = List();
  List<String> tags = List<String>();
  List<FStateMinimum> lessons = List<FStateMinimum>();
  //Props
  String descPath;
  String shortDesc;
  int time;
  String lang;
  String mbasepath;
  DocumentReference mdocref;
  ModerateBaseCurriculum moderateBaseCurriculum;
  ModerationCurriculum moderationCurriculum;
  String humanPath;
  String get path => widget.doc.reference.path;
  String get title => _titleController.text;

  void onlangchange(String nlang) {
    lang = nlang;
    BlocProvider.of<CurriculumBloc>(context).add(CurriculumChangedE(
        curriculum: moderationCurriculum,
        baseCurriculum: moderateBaseCurriculum));
    print(lang);
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _shortDescController = TextEditingController();
    descPath = getdescPath();
    moderateBaseCurriculum = ModerateBaseCurriculum(
        lang: null,
        title: null,
        tags: null,
        uid: null,
        timestamp: null,
        time: null,
        isModerating: null,
        humanPath: null);
    moderationCurriculum = ModerationCurriculum(
        lessons: null,
        descPath: null,
        lessonsCount: null,
        time: null,
        learns: null,
        requirments: null,
        shortDesc: null);
    // loadCurriculum();S
  }

  @override
  void dispose() {
    _titleController.dispose();
    _shortDescController.dispose();
    // descPath = getdescPath();
    // loadCurriculum();
    super.dispose();
  }

  bool isOk(r) {
    if (r == '/lesson') {
      return true;
    }
    return false;
  }

  String getdescPath() {
    final fpath = 'curriculumDesc/' +
        GetIt.I.get<User>().uid +
        '/' +
        Utils.CreateCryptoRandomString();
    return fpath;
  }

  Future<int> loadCurriculum() async {
    final currDoc = await widget.doc.reference
        .collection('curriculum')
        .document('curriculum')
        .get();
    moderateBaseCurriculum = ModerateBaseCurriculum.fromJson(widget.doc.data);
    moderationCurriculum = ModerationCurriculum.fromJson(currDoc.data);
    print('Base Curriculum: ${moderateBaseCurriculum.toJson().toString()}');
    print('Main Curriculum: ${moderationCurriculum.toJson().toString()}');
    _titleController.text = moderateBaseCurriculum.title;
    _shortDescController.text = moderationCurriculum.shortDesc;
    descPath = moderationCurriculum.descPath;
    time = moderateBaseCurriculum.time;
    lang = moderateBaseCurriculum.lang;
    humanPath = moderateBaseCurriculum.humanPath;
    learn = moderationCurriculum.learns;
    lessons = moderationCurriculum.lessons;
    tags = moderateBaseCurriculum.tags;
    requirements = moderationCurriculum.requirments;
    return 1;
  }

  _createCurriculum() {
    String l = lang;
    if (l == null) {
      l = FService.getLang(context);
    }
    // tags.addAll(FService.getTags(title));
    // final moderationPath = FService.getModerPath(path);

    moderateBaseCurriculum = ModerateBaseCurriculum(
        humanPath: humanPath,
        lang: l,
        title: title,
        tags: tags,
        uid: GetIt.I.get<User>().uid,
        timestamp: Timestamp.now(),
        time: time,
        isModerating: true);
    moderationCurriculum = ModerationCurriculum(
        lessons: lessons ?? List<FStateMinimum>(),
        descPath: descPath,
        // learnPath: null,
        lessonsCount: lessons?.length ?? 0,
        time: time,
        learns: learn,
        shortDesc: _shortDescController.text,
        requirments: requirements);
  }

  Future<void> _addCurriculum() async {
    try {
      _createCurriculum();
      tags.addAll(FService.getTags(title));
      humanPath = await FService.getHumanPath(widget.doc.reference);
      final pubPath = FService.getPubPath(path);
      final pubDocref = Firestore.instance.document(pubPath);
      final pubCurriculum = Curriculum(
          lessons: moderationCurriculum.lessons,
          descPath: moderationCurriculum.descPath,
          lessonsCount: moderationCurriculum.lessonsCount,
          time: moderationCurriculum.time,
          learns: moderationCurriculum.learns,
          requirments: moderationCurriculum.requirments,
          shortDesc: moderationCurriculum.shortDesc);
      final pubBaseCurriculum = BaseCurriculum(
          lang: moderateBaseCurriculum.lang,
          title: moderateBaseCurriculum.title,
          tags: moderateBaseCurriculum.tags,
          uid: moderateBaseCurriculum.uid,
          timestamp: Timestamp.now(),
          time: moderateBaseCurriculum.time,
          humanPath: moderateBaseCurriculum.humanPath);
      moderateBaseCurriculum = ModerateBaseCurriculum(
          lang: moderateBaseCurriculum.lang,
          title: moderateBaseCurriculum.title,
          tags: moderateBaseCurriculum.tags,
          uid: moderateBaseCurriculum.uid,
          timestamp: Timestamp.now(),
          time: moderateBaseCurriculum.time,
          humanPath: moderateBaseCurriculum.humanPath,
          isModerating: false,
          moderator: GetIt.I.get<User>().uid);
      await pubDocref.setData(pubBaseCurriculum.toJson(), merge: true);
      await pubDocref
          .collection('curriculum')
          .document('curriculum')
          .setData(pubCurriculum.toJson(), merge: true);
      await widget.doc.reference
          .setData(moderateBaseCurriculum.toJson(), merge: true);
      await widget.doc.reference
          .collection('curriculum')
          .document('curriculum')
          .setData(pubCurriculum.toJson(), merge: true);
      final ldocsnap = await pubDocref.get();
      Navigator.pushNamed(context, '/curriculum', arguments: ldocsnap);
    } catch (e) {
      DialogService.showErrorDialog(context, e.toString());
    }
  }

  bool inited = false;

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
          create: (context) {
            return CurriculumBloc()
              ..add(CurriculumChangedE(
                  curriculum: moderationCurriculum,
                  baseCurriculum: moderateBaseCurriculum));
          },
          child: Builder(builder: (context) {
            if (!inited) {
              _titleController.addListener(() {
                BlocProvider.of<CurriculumBloc>(context).add(CurriculumChangedE(
                    curriculum: moderationCurriculum,
                    baseCurriculum: moderateBaseCurriculum));
              });
              _shortDescController.addListener(() {
                BlocProvider.of<CurriculumBloc>(context).add(CurriculumChangedE(
                    curriculum: moderationCurriculum,
                    baseCurriculum: moderateBaseCurriculum));
              });
              // loadCurriculum();
              inited = !inited;
            }
            return FutureBuilder(
                future: loadCurriculum(),
                builder: (context, snap) {
                  if (snap.hasError) {
                    return FErrorWidget(error: snap.error.toString());
                  }
                  if (!snap.hasData) {
                    return LoadingWidget();
                  }
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                            AppLocalizations.of(context).descPath +
                                ': ' +
                                descPath,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Divider(),
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
                                  return moderateBaseCurriculum?.lang ??
                                      FService.getLang(context);
                                },
                              ),
                            ],
                          ),

                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: CurriculumTitleEditor(
                                controller: _titleController,
                                onChanged: () {
                                  _createCurriculum();
                                  BlocProvider.of<CurriculumBloc>(context).add(
                                      CurriculumChangedE(
                                          curriculum: moderationCurriculum,
                                          baseCurriculum:
                                              moderateBaseCurriculum));
                                },
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: TagsEditor(
                              onAddTag: (tag) {
                                tags.add(tag);
                                _createCurriculum();
                                BlocProvider.of<CurriculumBloc>(context).add(
                                    CurriculumChangedE(
                                        curriculum: moderationCurriculum,
                                        baseCurriculum:
                                            moderateBaseCurriculum));
                              },
                              onRemoveTag: (tag) {
                                tags.remove(tag);
                                _createCurriculum();
                                BlocProvider.of<CurriculumBloc>(context).add(
                                    CurriculumChangedE(
                                        curriculum: moderationCurriculum,
                                        baseCurriculum:
                                            moderateBaseCurriculum));
                              },
                              onStart: () {
                                return tags;
                              },
                            ),
                          ),
                          Divider(),
                          // Expanded(child: WhatToLearnWidget()),
                          MultipleStringsWidget(
                            title: AppLocalizations.of(context)
                                .writeCurriculumLearnTitle,
                            onAdd: (String str) {
                              learn.add(str);
                              _createCurriculum();
                              BlocProvider.of<CurriculumBloc>(context).add(
                                  CurriculumChangedE(
                                      curriculum: moderationCurriculum,
                                      baseCurriculum: moderateBaseCurriculum));
                            },
                            onRemove: (String str) {
                              learn.remove(str);
                              _createCurriculum();
                              BlocProvider.of<CurriculumBloc>(context).add(
                                  CurriculumChangedE(
                                      curriculum: moderationCurriculum,
                                      baseCurriculum: moderateBaseCurriculum));
                            },
                            onStart: () {
                              return learn;
                            },
                          ),
                          Divider(),
                          MultipleStringsWidget(
                            title: AppLocalizations.of(context).requirements,
                            onAdd: (s) {
                              requirements.add(s);
                              _createCurriculum();
                              BlocProvider.of<CurriculumBloc>(context).add(
                                  CurriculumChangedE(
                                      curriculum: moderationCurriculum,
                                      baseCurriculum: moderateBaseCurriculum));
                            },
                            onRemove: (s) {
                              requirements.remove(s);
                              _createCurriculum();
                              BlocProvider.of<CurriculumBloc>(context).add(
                                  CurriculumChangedE(
                                      curriculum: moderationCurriculum,
                                      baseCurriculum: moderateBaseCurriculum));
                            },
                            onStart: () {
                              return requirements;
                            },
                          ),
                          Divider(),
                          Text(
                            AppLocalizations.of(context).shortDesc,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          WriteShortDescWidget(
                            controller: _shortDescController,
                          ),

                          Divider(),
                          Builder(builder: (context) {
                            return ListTile(
                              trailing: Icon(Icons.edit),
                              title: Text(
                                AppLocalizations.of(context)
                                    .writeCurriculumDescTitle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                        context, '/writeDescCurriculum',
                                        arguments: descPath)
                                    .then((value) {
                                  print('desc final');
                                  BlocProvider.of<CurriculumBloc>(context)
                                      .add(CurriculumDescriptionChangeE());
                                });
                                // _createCurriculum();
                              },
                            );
                          }),

                          DescriptionWidget(descPath: descPath),
                          Divider(),
                          //Lessons picker
                          LessonsPickerWidget(
                            onAddState: (state) {
                              lessons.add(state);
                              _createCurriculum();
                              BlocProvider.of<CurriculumBloc>(context).add(
                                  CurriculumChangedE(
                                      curriculum: moderationCurriculum,
                                      baseCurriculum: moderateBaseCurriculum));
                            },
                            onRemoveState: (state) {
                              lessons.remove(state);
                              _createCurriculum();
                              BlocProvider.of<CurriculumBloc>(context).add(
                                  CurriculumChangedE(
                                      curriculum: moderationCurriculum,
                                      baseCurriculum: moderateBaseCurriculum));
                            },
                            onStart: () {
                              return lessons;
                            },
                          ),
                          //How much time
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              AppLocalizations.of(context).howmuchtime,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: HowMuchTimeWidget(
                              onChange: (int value) {
                                time = value;
                                _createCurriculum();
                                BlocProvider.of<CurriculumBloc>(context).add(
                                    CurriculumChangedE(
                                        curriculum: moderationCurriculum,
                                        baseCurriculum:
                                            moderateBaseCurriculum));
                              },
                              onStart: () {
                                return time;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Divider(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            child: BlocBuilder<CurriculumBloc, CurriculumState>(
                                builder: (context, state) {
                              if (state is CurriculumSuccesS) {
                                return RaisedButton(
                                  color: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 15),
                                  onPressed: () {
                                    _addCurriculum();
                                  },
                                  child: Container(
                                    // width: double.infinity,
                                    alignment: Alignment.center,
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .titleAddCurriculum,
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
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 15),
                                  onPressed: null,
                                  child: Container(
                                    // width: double.infinity,
                                    alignment: Alignment.center,
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .titleAddCurriculum,
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
                  );
                });
          }),
        ),
      ),
    );
  }
}
