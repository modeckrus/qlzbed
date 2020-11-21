import 'package:flutter/material.dart';
import 'package:qlzbed/entities/fstateMinimum.dart';
import 'package:qlzbed/localization/localizations.dart';

class LessonsView extends StatefulWidget {
  final List<FStateMinimum> lessons;
  LessonsView({Key key, @required this.lessons}) : super(key: key);

  @override
  _LessonsViewState createState() => _LessonsViewState();
}

class _LessonsViewState extends State<LessonsView> {
  List<FStateMinimum> get lessons => widget.lessons;
  bool isShort = true;

  Widget lessonBuilder(FStateMinimum lesson) {
    return ListTile(
      leading: Icon(Icons.check),
      title: Text(
        lesson.title ?? '',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }

  List<Widget> buildShortLessons() {
    List<Widget> children = List();
    if (lessons.length > 4) {
      for (var i = 0; i < 20; i++) {
        children.add(lessonBuilder(lessons[i]));
      }
    } else {
      for (var string in lessons) {
        children.add(lessonBuilder(string));
      }
    }
    return children;
  }

  List<Widget> buildLongLessons() {
    List<Widget> children = List();
    for (var string in lessons) {
      children.add(lessonBuilder(string));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(15),
          color: Theme.of(context).appBarTheme.color,
          child: Column(
            children: [
              Column(
                children: isShort ? buildShortLessons() : buildLongLessons(),
              ),
              isShort
                  ? ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context).deploy + '...',
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).accentColor),
                            textAlign: TextAlign.center,
                          ),
                          Icon(Icons.arrow_downward),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          isShort = false;
                        });
                      },
                    )
                  : ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context).rollUp + '...↑',
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).accentColor),
                            textAlign: TextAlign.center,
                          ),
                          Icon(Icons.arrow_upward)
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          isShort = true;
                        });
                      },
                    ),
            ],
          )),
    );
  }
}
