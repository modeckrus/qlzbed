import 'package:flutter/material.dart';
import 'package:qlzbed/localization/localizations.dart';

class MultipleStringView extends StatefulWidget {
  final List<String> strings;
  MultipleStringView({Key key, @required this.strings}) : super(key: key);

  @override
  _MultipleStringViewState createState() => _MultipleStringViewState();
}

class _MultipleStringViewState extends State<MultipleStringView> {
  List<String> get strings => widget.strings;
  bool isShort = true;

  Widget stringBuilder(String tag) {
    return ListTile(
      leading: Icon(Icons.check),
      title: Text(
        tag ?? '',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }

  List<Widget> buildShortStrings() {
    List<Widget> children = List();
    if (strings.length > 4) {
      for (var i = 0; i < 20; i++) {
        children.add(stringBuilder(strings[i]));
      }
    } else {
      for (var string in strings) {
        children.add(stringBuilder(string));
      }
    }
    return children;
  }

  List<Widget> buildLongStrings() {
    List<Widget> children = List();
    for (var string in strings) {
      children.add(stringBuilder(string));
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
                children: isShort ? buildShortStrings() : buildLongStrings(),
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
