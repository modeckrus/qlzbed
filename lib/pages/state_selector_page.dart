import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../localization/localizations.dart';
import '../my_icons.dart';
import '../service/fservice.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

class StateSelectorPage extends StatefulWidget {
  final List<String> routesAllowed;

  const StateSelectorPage({Key key, @required this.routesAllowed})
      : super(key: key);
  @override
  _StateSelectorPageState createState() => _StateSelectorPageState();
}

class _StateSelectorPageState extends State<StateSelectorPage> {
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
                        return StateSelectorListTile(
                          doc: doc,
                          routesAllowed: widget.routesAllowed,
                        );
                      },
                      childCount: snap.data.documents.length,
                    ),
                  ),
                ],
              );
            }));
  }
}

class StateSelectorList extends StatefulWidget {
  final DocumentSnapshot doc;
  final List<String> routesAllowed;
  const StateSelectorList(
      {Key key, @required this.doc, @required this.routesAllowed})
      : super(key: key);
  @override
  _StateSelectorListState createState() => _StateSelectorListState();
}

class _StateSelectorListState extends State<StateSelectorList> {
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
                  return StateSelectorListTile(
                    doc: data.documents[index],
                    routesAllowed: widget.routesAllowed,
                  );
                });
          },
        ),
      ),
    );
  }
}

class StateSelectorListTile extends StatefulWidget {
  final DocumentSnapshot doc;
  final List<String> routesAllowed;
  const StateSelectorListTile(
      {Key key, @required this.doc, @required this.routesAllowed})
      : super(key: key);

  @override
  _StateSelectorListTileState createState() => _StateSelectorListTileState();
}

class _StateSelectorListTileState extends State<StateSelectorListTile> {
  String get route => widget.doc.data['route'];
  bool isOk() {
    if (widget.routesAllowed.contains(route)) {
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
            FService.getStateSelectorPath(widget.doc.reference.path);
        print(stateroute);
        final DocumentSnapshot result = await Navigator.pushNamed(
            context, '/stateSelectorList',
            arguments: [widget.doc, widget.routesAllowed]);
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
