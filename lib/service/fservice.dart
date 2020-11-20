import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../my_icons.dart';

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

  static String getPubPath(String path) {
    if (path.contains('moderation')) {
      final lpart = path.split('moderation/')[1];
      print(lpart);
      final List<String> list = List();
      lpart.split('moderationList/').forEach((element) {
        list.add(element);
      });
      final fpath = list.join('list/');
      final docref = Firestore.instance.collection('routes').document(fpath);
      return docref.path;
    } else {
      return path;
    }
  }

  static String getStateSelectorPath(String path) {
    final List<String> list = List();
    path.split('list/').forEach((element) {
      list.add(element);
    });
    final fpath = list.join('stateSelectorList/');
    return fpath;
  }

  static String getLessonSelectorPath(String path) {
    final List<String> list = List();
    path.split('list/').forEach((element) {
      list.add(element);
    });
    final fpath = list.join('lessonSelectorList/');
    return fpath;
  }

  static Widget getIconByRoute(String route) {
    Widget icon = MyIcons.article;
    if (route == '/list') {
      icon = MyIcons.group;
    }
    if (route == '/article') {
      icon = MyIcons.article;
    }
    if (route == '/testText') {
      icon = MyIcons.textTest;
    }
    if (route == '/checkTest') {
      icon = MyIcons.checkTest;
    }
    if (route == '/lesson') {
      icon = MyIcons.lesson;
    }
    if (route == '/unit') {
      icon = MyIcons.unit;
    }
    if (route == '/curriculum') {
      icon = MyIcons.curriculum;
    }
    return icon;
  }

  static getModerationRoute(String route) {
    String mroute = '/';
    if (route == '/article') {
      mroute = '/moderateArticle';
    }
    if (route == '/testText') {
      mroute = '/moderateTestText';
    }
    if (route == '/checkTest') {
      mroute = '/moderateCheckTest';
    }
    if (route == '/list') {
      mroute = '/moderateList';
    }
    if (route == '/lesson') {
      mroute = '/moderateLesson';
    }
    if (route == '/unit') {
      mroute = '/moderateUnit';
    }
    if (route == '/curriculum') {
      mroute = '/moderateCurriculum';
    }
    return mroute;
  }

  static Future<String> getHumanPath(DocumentReference reference) async {
    String humanString = '';
    // final firsttitle = (await reference.get()).data['title'];
    // humanString += firsttitle;
    final path = reference.path;
    final listStrings = path.split('moderationList');
    for (var i = 0; i < listStrings.length; i++) {
      final sstring = listStrings.getRange(0, i + 1).join('moderationList');
      humanString +=
          (await Firestore.instance.document(sstring).get()).data['title'] +
              '/';
      print(sstring);
    }
    print(humanString);
    return humanString;
  }

  static String getLang(BuildContext context) {
    final langcode = Localizations.localeOf(context).languageCode;
    print(langcode);
    return langcode;
  }

  static List<String> getTags(String title) {
    List<String> tags = List();
    title.split(' ').forEach((element) {
      for (var i = 1; i < element.length; i++) {
        final part = element.substring(0, i);
        if (!tags.contains(part)) {
          tags.add(part.toLowerCase().replaceAll(' ', ''));
        }
      }
    });
    return tags;
  }
}
