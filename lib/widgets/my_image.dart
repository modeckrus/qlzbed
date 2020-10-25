import 'package:flutter/material.dart';

import '../entities/msize.dart';
import '../service/fstore_cahe_manager.dart';

class MyImage extends StatefulWidget {
  final String path;
  final MSize size;
  MyImage({Key key, @required this.path, this.size}) : super(key: key);

  @override
  _MyImageState createState() => _MyImageState();
}

class _MyImageState extends State<MyImage> {
  @override
  Widget build(BuildContext context) {
    if (widget.path == null || widget.path == '') {
      return Container();
    }
    return FutureBuilder(
        future: FStoreCacheManager().getFStoreFile(widget.path),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error);
          }
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          if (snapshot.data == '' || snapshot.data == ' ') {
            return CircularProgressIndicator();
          }
          return Image.file(
            snapshot.data,
            filterQuality: FilterQuality.low,
            fit: BoxFit.cover,
          );
        });
  }
}
