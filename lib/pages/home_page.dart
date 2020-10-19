import 'package:flutter/material.dart';

import '../localization/localizations.dart';
import 'account_page.dart';
import 'feed_page.dart';
import 'library_page.dart';
import 'messages_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  PageController _pageController;
  @override
  void initState() {
    _pageController = PageController(initialPage: currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.blueGrey,
          selectedItemColor: Colors.lightBlue,
          onTap: (index) {
            // setState(() {
            //   currentIndex = index;
            // });
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          },
          currentIndex: currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.article_outlined),
                label: AppLocalizations.of(context).feed),
            BottomNavigationBarItem(
                icon: Icon(Icons.lightbulb),
                label: AppLocalizations.of(context).library),
            BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: AppLocalizations.of(context).messages),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_rounded),
                label: AppLocalizations.of(context).account),
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          children: [FeedPage(), LibraryPage(), MessagesPage(), AccountPage()],
        ),
      ),
    );
  }

  Widget _getBody() {
    switch (currentIndex) {
      case 0:
        return FeedPage();
        break;
      case 1:
        return LibraryPage();
        break;
      case 2:
        return MessagesPage();
      case 3:
        return AccountPage();
      default:
        return Container();
    }
  }
}
