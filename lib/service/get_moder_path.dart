import 'package:cloud_firestore/cloud_firestore.dart';

class FService {
  static String getModerPath(String path) {
    if (path.contains('routes')) {
      final lpart = path.split('routes/')[1];
      print(lpart);
      final List<String> list = List();
      lpart.split('list/').forEach((element) {
        list.add(element);
      });
      final fpath = list.join('moderationList/');
      final docref =
          Firestore.instance.collection('moderation').document(fpath);
      return docref.path;
    } else {
      return path;
    }
  }
}
