import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qlzbed/pages/curriculum/curriculum_page.dart';
import 'package:qlzbed/pages/tests/write_tests_page.dart';

import 'entities/dialog.dart';
import 'pages/add_checktest_page.dart';
import 'pages/add_formula_page.dart';
import 'pages/add_state_page.dart';
import 'pages/add_texttest_page.dart';
import 'pages/article/add_article_page.dart';
import 'pages/article/article_page.dart';
import 'pages/article/moderate_add_article_page.dart';
import 'pages/article/moderate_article_page.dart';
import 'pages/article/wrtie_article_page.dart';
import 'pages/curriculum/add_curriculum_page.dart';
import 'pages/curriculum/moderate_add_curriculum_page.dart';
import 'pages/curriculum/moderate_desc_curriculum_page.dart';
import 'pages/curriculum/write_desc_curriculum_page.dart';
import 'pages/dialog_page.dart';
import 'pages/error_page.dart';
import 'pages/grop/add_group_page.dart';
import 'pages/grop/list_page.dart';
import 'pages/grop/moderate_add_group_page.dart';
import 'pages/grop/moderate_group_page.dart';
import 'pages/initial_page.dart';
import 'pages/lesson/add_lesson_page.dart';
import 'pages/lesson/lesson_page.dart';
import 'pages/lesson/moderate_lesson_page.dart';
import 'pages/lesson_selector_page.dart';
import 'pages/moderate_page.dart';
import 'pages/settings_page.dart';
import 'pages/spec_moderate_list_page.dart';
import 'pages/state_selector_page.dart';
import 'pages/test_page.dart';
import 'pages/unit/add_unit_page.dart';
import 'pages/unit/moderate_unit_page.dart';
import 'pages/unit/unit_page.dart';
import 'service/route_transitions.dart';
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
      case '/curriculum':
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
            builder: (_) => CurriculumPage(doc: doc),
            animationType: AnimationType.slide_right,
            curves: Curves.easeInOut);
      case '/specmoderateList':
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
            builder: (_) => FSpecModerateListPage(doc: doc),
            animationType: AnimationType.slide_right,
            curves: Curves.easeInOut);
      case '/stateSelectorList':
        final List<dynamic> ars = args as List<dynamic>;
        final DocumentSnapshot doc = ars[0];
        final List<String> routesAllowed = ars[1];
        return PageRouteTransition<DocumentSnapshot>(
            builder: (_) => StateSelectorList(
                  doc: doc,
                  routesAllowed: routesAllowed,
                ),
            animationType: AnimationType.slide_right,
            curves: Curves.easeInOut);
      case '/lessonSelectorList':
        final DocumentSnapshot doc = args;
        return PageRouteTransition<DocumentSnapshot>(
            builder: (_) => LessonSelectorList(doc: doc),
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
      case '/addLesson':
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => AddLessonPage(
            doc: doc,
          ),
        );
      case '/addUnit':
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => AddUnitPage(
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
      case '/moderation':
      case '/moderate':
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => ModeratePage(),
        );
      case '/moderateArticle':
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => ModerateArticlePage(
            doc: doc,
          ),
        );
      case '/addTests':
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => WriteTestsPage(
            doc: doc,
          ),
        );
      case '/moderateGroup':
      case '/moderateList':
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => ModerateGroupPage(
            doc: doc,
          ),
        );
      case '/moderateAddGroup':
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => ModerateAddGroupPage(
            doc: doc,
          ),
        );
      case '/moderateAddArticle':
        List<dynamic> ars = args;
        final DocumentSnapshot doc = ars[0];
        final String filepath = ars[1];
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => ModerateAddArticlePage(
            doc: doc,
            filepath: filepath,
          ),
        );
      case '/moderateLesson':
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => ModerateAddLessonPage(
            doc: doc,
          ),
        );
      case '/moderateUnit':
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => ModerateAddUnitPage(
            doc: doc,
          ),
        );
      case '/lesson':
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => LessonPage(
            doc: doc,
          ),
        );
      case '/unit':
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => UnitPage(
            doc: doc,
          ),
        );
      case '/writeDescCurriculum':
        // List<dynamic> ars = args;
        // final DocumentSnapshot doc = ars[0];
        // final String learnPath = ars[1];
        final String descPath = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => WriteCurriculumDescPage(
            descPath: descPath,
            // doc: doc,
            // learnPath: learnPath,
          ),
        );
      case '/addCurriculum':
        // List<dynamic> ars = args;
        // final DocumentSnapshot doc = ars[0];
        // final String learnPath = ars[1];
        // final String descPath = ars[2];
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => AddCurriculumPage(
            doc: doc,
            // learnPath: learnPath,
            // descPath: descPath,
          ),
        );
      case '/moderateDescCurriculum':
        List<dynamic> ars = args;
        final DocumentSnapshot doc = ars[0];
        final String learnPath = ars[1];
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => ModerateDescCurriculumPage(
            doc: doc,
            learnPath: learnPath,
          ),
        );
      case '/moderateCurriculum':
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => ModerateAddCurriculumPage(
            doc: doc,
          ),
        );
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
      case '/selectState':
        final List<String> routesAllowed = args;
        return PageRouteTransition<DocumentSnapshot>(
            animationType: AnimationType.slide_right,
            curves: Curves.easeInOut,
            builder: (context) => StateSelectorPage(
                  routesAllowed: routesAllowed,
                ));
      case '/selectLesson':
        return PageRouteTransition<DocumentSnapshot>(
            animationType: AnimationType.slide_right,
            curves: Curves.easeInOut,
            builder: (context) => LessonSelectorPage());
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
