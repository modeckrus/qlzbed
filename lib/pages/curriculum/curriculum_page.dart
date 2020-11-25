import '../../entities/timestamp.dart';
import 'package:flutter/material.dart';
import '../../entities/base_curriculum.dart';
import '../../entities/curriculum.dart';
import '../../localization/localizations.dart';
import 'descprition_widget.dart';
import 'lessons_view.dart';
import 'multiple_string_view.dart';
import '../../service/firebase_service.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/tags_view_widget.dart';

import 'description_view_widget.dart';

class CurriculumPage extends StatefulWidget {
  final DocumentSnapshot doc;
  CurriculumPage({Key key, @required this.doc}) : super(key: key);

  @override
  _CurriculumPageState createState() => _CurriculumPageState();
}

class _CurriculumPageState extends State<CurriculumPage> {
  Curriculum curriculum;
  BaseCurriculum baseCurriculum;
  DocumentSnapshot curDoc;

  Future<int> loadDocument() async {
    curDoc = await widget.doc.reference
        .collection('curriculum')
        .document('curriculum')
        .get();
    curriculum = Curriculum.fromJson(curDoc.data);
    return 1;
  }

  @override
  void initState() {
    super.initState();
    baseCurriculum = BaseCurriculum.fromJson(widget.doc.data);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
          body: CustomScrollView(slivers: [
            SliverAppBar(
                expandedHeight: 200,
                centerTitle: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Colors.black,
                  ),
                ),
                title: Text(baseCurriculum.title ??
                    AppLocalizations.of(context).titleAddCurriculum),
                actions: [
                  IconButton(
                      icon: Icon(Icons.home),
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      })
                ]),
            SliverToBoxAdapter(
              child: FutureBuilder(
                future: loadDocument(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return FErrorWidget(error: snapshot.error.toString());
                  }
                  if (!snapshot.hasData) {
                    return LoadingWidget();
                  }
                  return buildBody();
                },
              ),
            )
          ]),
        ));
  }

  Widget buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildShortDesc(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildInfo(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildLearns(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildRequirements(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildDescription(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildLessons(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildRecomendations(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildCommentary(),
        ),
      ],
    );
  }

  Widget buildInfo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: TagsViewWidget(tags: baseCurriculum.tags),
    );
  }

  Widget buildLearns() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Theme.of(context).appBarTheme.color,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: Text(
                AppLocalizations.of(context).whatYouWillLearn,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            MultipleStringView(strings: curriculum.learns),
          ],
        ),
      ),
    );
  }

  Widget buildRequirements() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Theme.of(context).appBarTheme.color,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: Text(
                AppLocalizations.of(context).requirements,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            MultipleStringView(strings: curriculum.requirments),
          ],
        ),
      ),
    );
  }

  Widget buildShortDesc() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15),
        color: Theme.of(context).appBarTheme.color,
        child: Text(
          curriculum.shortDesc,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget buildDescription() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Theme.of(context).appBarTheme.color,
        child: DescriptionViewWidget(
          descPath: curriculum.descPath,
        ),
      ),
    );
  }

  Widget buildRecomendations() {
    return Container();
  }

  Widget buildLessons() {
    final Widget currPlan = ListTile(
      tileColor: Theme.of(context).appBarTheme.color,
      title: Text(AppLocalizations.of(context).curriculum),
      subtitle: Text(AppLocalizations.of(context).lectures +
          '(' +
          curriculum.lessonsCount.toString() +
          ') \t' +
          AppLocalizations.of(context).total +
          '(' +
          curriculum.time.toString() +
          ')'),
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: currPlan,
        ),
        LessonsView(lessons: curriculum.lessons)
      ],
    );
  }

  Widget buildAuthor() {
    return Container();
  }

  Widget buildCommentary() {
    return Container();
  }
}
