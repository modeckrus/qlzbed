import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../localization/localizations.dart';
import '../../qlzb/qlzb/qlzb.dart';
import '../../qlzb/qlzb/src/widgets/view.dart';
import 'bloc/curriculum_bloc.dart';

class DescriptionWidget extends StatefulWidget {
  final String descPath;
  DescriptionWidget({Key key, @required this.descPath}) : super(key: key);

  @override
  _DescriptionWidgetState createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<DescriptionWidget> {
  QDocDocument document;
  bool isShort = true;
  // ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    document = QDocDocument()..insert(0, '\n');
    loadDocument();
    // _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  QDocDocument getShortDocument() {
    if (document.length > 500) {
      return QDocDocument.fromDelta(
          document.delete(500, document.length - 499));
    }
    return document;
  }

  Future<void> loadDocument() async {
    try {
      final data = await FirebaseStorage.instance
          .ref()
          .child(widget.descPath)
          .getData(50 * 1024 * 1024);
      if (data != null && data.isNotEmpty) {
        // ensure
        final string = utf8.decode(data);
        document = QDocDocument.fromJson(jsonDecode(string));
        if (super.mounted) {
          setState(() {});
        }
      } else {
        document = QDocDocument()
          ..insert(0, AppLocalizations.of(context).error);
        if (super.mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      if (e.runtimeType == PlatformException &&
          (e as PlatformException).code == 'download_error') {
        print('DownloadError: $e');
        document = QDocDocument()
          ..insert(0, AppLocalizations.of(context).doesNotExist);
        document.format(0, document.length - 1, QDocAttribute.color10);
        document.format(0, document.length - 1, QDocAttribute.heading.level1);
        if (super.mounted) {
          setState(() {});
        }
      } else {
        print(e);
        document = QDocDocument()
          ..insert(0, AppLocalizations.of(context).error + ': ' + e.toString());
        if (super.mounted) {
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // loadDocument();
    return BlocListener<CurriculumBloc, CurriculumState>(
      listener: (context, state) {
        if (state is CurriculumDescChangedS) {
          loadDocument();
        }
      },
      child: Container(
          // width: 200,
          padding: EdgeInsets.all(20),
          // height: 200,
          child: Column(
            children: [
              Container(
                height: isShort ? 200 : null,
                child:
                    SingleChildScrollView(child: QlzbView(document: document)),
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
