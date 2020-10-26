import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qlzbed/localization/localizations.dart';
import 'package:qlzbed/my_icons.dart';

class AddStatePage extends StatefulWidget {
  final DocumentSnapshot doc;

  const AddStatePage({Key key, @required this.doc}) : super(key: key);
  @override
  _AddStatePageState createState() => _AddStatePageState();
}

class _AddStatePageState extends State<AddStatePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).titleAddState),
          actions: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context).topTextforaddState,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  )),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ListView(
                  children: [
                    ListTile(
                      leading: MyIcons.group,
                      title: Text(
                        AppLocalizations.of(context).titleAddGroup,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      trailing: MyIcons.nextRoute,
                      onTap: () {
                        Navigator.pushNamed(context, '/addGroup',
                            arguments: widget.doc);
                      },
                    ),
                    ListTile(
                      leading: MyIcons.article,
                      title: Text(
                        AppLocalizations.of(context).titleAddArticle,
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: MyIcons.nextRoute,
                      onTap: () {
                        Navigator.pushNamed(context, '/writeArticle',
                            arguments: widget.doc);
                      },
                    ),
                    ListTile(
                      leading: MyIcons.textTest,
                      title: Text(
                        AppLocalizations.of(context).titleTextTest,
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: MyIcons.nextRoute,
                      onTap: () {
                        Navigator.pushNamed(context, '/addTextTest',
                            arguments: widget.doc);
                      },
                    ),
                    ListTile(
                      leading: MyIcons.checkTest,
                      title: Text(
                        AppLocalizations.of(context).titleCheckTest,
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: MyIcons.nextRoute,
                      onTap: () {
                        Navigator.pushNamed(context, '/addCheckTest',
                            arguments: widget.doc);
                      },
                    ),
                    ListTile(
                      leading: MyIcons.formula,
                      title: Text(
                        AppLocalizations.of(context).titleAddFormula,
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: MyIcons.nextRoute,
                      onTap: () {
                        Navigator.pushNamed(context, '/addFormula',
                            arguments: widget.doc);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
