import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../authentication/bloc/authentication_bloc.dart';
import '../user_repository.dart';
import '../widgets/button/bloc/button_bloc.dart';
import 'bloc/login_bloc.dart';
import 'login_form.dart';

class LoginPage extends StatelessWidget {
  final UserRepository userRepository;
  const LoginPage({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
              userRepository: userRepository,
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)),
          child: BlocProvider<ButtonBloc>(
            create: (context) => ButtonBloc(),
            child: SingleChildScrollView(
                child: LoginForm(userRepository: userRepository)),
          )),
    );
  }
}
