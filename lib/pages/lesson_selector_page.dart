import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qlzbed/localization/localizations.dart';
import 'package:qlzbed/my_icons.dart';
import 'package:qlzbed/service/fservice.dart';
import 'package:qlzbed/widgets/error_widget.dart';
import 'package:qlzbed/widgets/loading_widget.dart';

class LessonSelectorPage extends StatefulWidget {
  @override
  _LessonSelectorPageState createState() => _LessonSelectorPageState();
}

class _LessonSelectorPageState extends State<LessonSelectorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).stateSelector),
        ),
        body: StreamBuilder(
            stream: Firestore.instance
                .collection('routes')
                .document(FService.getLang(context))
                .collection('mainRoutes')
                .snapshots(),
            builder: (context, snap) {
              if (!snap.hasData) {
                return LoadingWidget();
              }
              if (snap.hasError) {
                return FErrorWidget(error: snap.error.toString());
              }

              var countryCode = FService.getLang(context);
              print({'Locale: ': countryCode});
              // QuerySnapshot querySnap = snap.data;
              // print(querySnap.documents);
              //print(snap.data.documents['Title'].data['title']);
              return CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final doc = snap.data.documents[index];
                        return LessonSelectorListTile(doc: doc);
                      },
                      childCount: snap.data.documents.length,
                    ),
                  ),
                ],
              );
            }));
  }
}

class LessonSelectorList extends StatefulWidget {
  final DocumentSnapshot doc;

  const LessonSelectorList({Key key, @required this.doc}) : super(key: key);
  @override
  _LessonSelectorListState createState() => _LessonSelectorListState();
}

class _LessonSelectorListState extends State<LessonSelectorList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.doc.data['title']),
        ),
        body: StreamBuilder(
          stream: Firestore.instance
              .collection(widget.doc.reference.path + '/list')
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!(snapshot.hasData)) {
              return LoadingWidget();
            }
            if (snapshot.hasError) {
              return ErrorWidget(snapshot.error);
            }

            QuerySnapshot data = snapshot.data;
            return ListView.builder(
                itemCount: data.documents.length,
                itemBuilder: (context, index) {
                  return LessonSelectorListTile(doc: data.documents[index]);
                });
          },
        ),
      ),
    );
  }
}

class LessonSelectorListTile extends StatefulWidget {
  final DocumentSnapshot doc;

  const LessonSelectorListTile({Key key, @required this.doc}) : super(key: key);

  @override
  _LessonSelectorListTileState createState() => _LessonSelectorListTileState();
}

class _LessonSelectorListTileState extends State<LessonSelectorListTile> {
  String get route => widget.doc.data['route'];
  bool isOk() {
    if (route == '/lesson') {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Widget icon = FService.getIconByRoute(widget.doc.data['route']);
    return GestureDetector(
      onTap: () async {
        print('tapped');
        final stateroute =
            FService.getLessonSelectorPath(widget.doc.reference.path);
        print(stateroute);
        final DocumentSnapshot result = await Navigator.pushNamed(
            context, '/lessonSelectorList',
            arguments: widget.doc);
        if (result != null) {
          Navigator.pop(context, result);
        }
      },
      child: Container(
        height: 80,
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            color: Colors.black38,
            child: ListTile(
              leading: icon,
              title: Text(
                widget.doc.data['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              trailing: isOk()
                  ? IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        Navigator.pop(context, widget.doc);
                      },
                    )
                  : MyIcons.nextRoute,
            ),
          ),
        ),
      ),
    );
  }
}
