import 'package:flutter/material.dart';
import 'package:qlzbed/localization/localizations.dart';

class TagsViewWidget extends StatefulWidget {
  final List<String> tags;
  TagsViewWidget({Key key, @required this.tags}) : super(key: key);

  @override
  _TagsViewWidgetState createState() => _TagsViewWidgetState();
}

class _TagsViewWidgetState extends State<TagsViewWidget> {
  List<String> get tags => widget.tags;
  bool isShort = true;
  Widget tagBuilder(String tag) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          color: Theme.of(context).buttonColor,
          child: Text(tag ?? ''),
        ),
      ),
    );
  }

  List<Widget> buildShortTags() {
    List<Widget> children = List();
    if (tags.length > 20) {
      for (var i = 0; i < 20; i++) {
        children.add(tagBuilder(tags[i]));
      }
    } else {
      for (var tag in tags) {
        children.add(tagBuilder(tag));
      }
    }
    return children;
  }

  List<Widget> buildLongTags() {
    List<Widget> children = List();
    for (var tag in tags) {
      children.add(tagBuilder(tag));
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
              Wrap(
                children: isShort ? buildShortTags() : buildLongTags(),
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
