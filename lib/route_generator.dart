import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qlzbed/entities/dialog.dart';
import 'package:qlzbed/pages/dialog_page.dart';
import 'package:route_transitions/route_transitions.dart';

import 'pages/error_page.dart';
import 'pages/initial_page.dart';
import 'pages/list_page.dart';
import 'pages/settings_page.dart';
import 'pages/test_page.dart';
import 'user_repository.dart';
import 'zefyr/reading_page.dart';

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
      // case '/home':
      //   return PageRouteTransition(
      //       animationType: AnimationType.fade,
      //       curves: Curves.easeInOut,
      //       builder: (_) => HomePage());
      //   break;
      // case '/login':
      //   return PageRouteTransition(
      //       animationType: AnimationType.slide_right,
      //       curves: Curves.easeInOut,
      //       builder: (_) => LoginPage());
      //   break;
      // case '/settinguser':
      //   return PageRouteTransition(
      //       animationType: AnimationType.fade,
      //       curves: Curves.easeInOut,
      //       builder: (_) => SettingUserPage());
      //   break;
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
      case '/readingPage':
      case '/article':
        final DocumentSnapshot doc = args;
        return PageRouteTransition(
          animationType: AnimationType.slide_right,
          curves: Curves.easeInOut,
          builder: (context) => ReadingPage(
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
      // case '/testPhone':
      //   return PageRouteTransition(
      //       animationType: AnimationType.fade,
      //       curves: Curves.easeInOut,
      //       builder: (context) => TestPhone());
      // case '/smscode':
      //   final list = args as List;
      //   final phoneNumber = list[0];
      //   final verId = list[1];
      //   return PageRouteTransition(
      //       animationType: AnimationType.fade,
      //       curves: Curves.ease,
      //       builder: (_) => SmsCodePage(
      //             phoneNumber: phoneNumber,
      //             verificationId: verId,
      //           ));
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
