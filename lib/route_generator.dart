import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qlzbed/entities/dialog.dart';
import 'package:qlzbed/pages/add_article_page.dart';
import 'package:qlzbed/pages/add_checktest_page.dart';
import 'package:qlzbed/pages/add_formula_page.dart';
import 'package:qlzbed/pages/add_group_page.dart';
import 'package:qlzbed/pages/add_state_page.dart';
import 'package:qlzbed/pages/add_texttest_page.dart';
import 'package:qlzbed/pages/article_page.dart';
import 'package:qlzbed/pages/dialog_page.dart';
import 'package:qlzbed/pages/text_test_page.dart';
import 'package:qlzbed/pages/wrtie_article_page.dart';
import 'package:route_transitions/route_transitions.dart';

import 'pages/error_page.dart';
import 'pages/initial_page.dart';
import 'pages/list_page.dart';
import 'pages/settings_page.dart';
import 'pages/test_page.dart';
import 'user_repository.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(
      RouteSettings settings, UserRepository userRepository) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return PageRouteTransition(
            builder: (_) => InitialPage(userRepository: userRepository),
            animationType: AnimationType.fade,
            curves: Curves.easeInOut);
        break;
      case '/list':
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
            builder: (_) => FListPage(doc: doc),
            animationType: AnimationType.slide_right,
            curves: Curves.easeInOut);
      case '/settings':
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => SettingsPage(),
        );
        break;
      case '/test':
        return PageRouteTransition(
          animationType: AnimationType.fade,
          curves: Curves.easeInOut,
          builder: (context) => TestPage(),
        );
        break;
      case '/addState':
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => AddStatePage(
            doc: doc,
          ),
        );
      case '/addGroup':
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => AddGroupPage(
            doc: doc,
          ),
        );
      case '/addArticle':
        List<dynamic> ars = args;
        final DocumentSnapshot doc = ars[0];
        final String filepath = ars[1];
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => AddArticlePage(
            doc: doc,
            filepath: filepath,
          ),
        );
      case '/writeArticle':
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => WriteArticlePage(
            doc: doc,
          ),
        );
      case '/addTextTest':
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => AddTextTestPage(
            doc: doc,
          ),
        );
      case '/addCheckTest':
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => AddCheckTestPage(
            doc: doc,
          ),
        );
      case '/addFormula':
        // final DocumentSnapshot doc = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => AddFormulaPage(),
        );
      case '/textTest':
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => TextTestPage(
            doc: doc,
          ),
        );
      case '/readingPage':
      case '/article':
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => ArticlePage(
            doc: doc,
          ),
        );
        break;
      case '/dialogPage':
      case '/dialogRoom':
        final MDialog dialog = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => DialogPage(
            dialog: dialog,
          ),
        );
      default:
        return PageRouteTransition(
            animationType: AnimationType.fade,
            curves: Curves.easeInOut,
            builder: (_) => ErrorPage(
                  error: 'No such Page',
                ));
    }
  }
}
