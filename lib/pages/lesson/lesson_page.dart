import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../entities/fstateMinimum.dart';
import '../../entities/lesson.dart';
import '../../my_icons.dart';
import '../../service/dialog_sevice.dart';
import '../../widgets/state_builder_widget.dart';

class LessonPage extends StatefulWidget {
  final DocumentSnapshot doc;

  const LessonPage({Key key, @required this.doc}) : super(key: key);
  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  PageController _pageController;
  Lesson lesson;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );
    try {
      lesson = Lesson.fromJson(widget.doc.data);
    } catch (e) {
      print('Error in initState in LessonPage: ${e.toString()}');
      // DialogService.showErrorDialog(context, e.toString());
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget buildState(FStateMinimum state) {
    return StateBuilderWidget(
      state: state,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: MyIcons.more,
                onPressed: () {
                  DialogService.showMoreDialog(context, widget.doc.reference);
                },
              ),
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
              )
            ],
            title: Text(widget.doc['title']),
          ),
          body: Builder(
            builder: (context) {
              final lesson = Lesson.fromJson(widget.doc.data);
              List<Widget> children = List();
              for (var i = 0; i < lesson.states.length; i++) {
                children.add(buildState(lesson.states[i]));
              }
              if (children.length == 0) {
                children.add(Container());
              }
              return PageView(
                controller: _pageController,
                children: children,
              );
            },
          )),
    );
  }
}
