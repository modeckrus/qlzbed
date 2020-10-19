import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../authentication/bloc/authentication_bloc.dart';
import '../login/login_page.dart';
import '../settingUser/settingUser_page.dart';
import '../user_repository.dart';
import 'hello_page.dart';
import 'home_page.dart';

class InitialPage extends StatefulWidget {
  final UserRepository userRepository;
  static const String routeName = '/';
  InitialPage({Key key, @required this.userRepository}) : super(key: key);

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      return SafeArea(child: Scaffold(
        body: Builder(builder: (context) {
          return buildBody(state);
        }),
      ));
    });
  }

  Widget buildBody(AuthenticationState state) {
    if (state is Uninitialized) {
      return Container();
    }
    if (state is Unauthenticated) {
      return HelloPage();
    }
    if (state is Authenticated) {
      return HomePage();
    }
    if (state is SettingUser) {
      return SettingUserPage();
    }
    if (state is LogPageS) {
      return LoginPage(
        userRepository: widget.userRepository,
      );
    }
    return Container();
  }
}
