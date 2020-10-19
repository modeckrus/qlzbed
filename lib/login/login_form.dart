import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../localization/localizations.dart';
import '../user_repository.dart';
import '../validators.dart';
import '../widgets/button/bloc/button_bloc.dart';
import '../widgets/button/create_an_account_button.dart';
import '../widgets/button/google_login_button.dart';
import '../widgets/button/login_button.dart';
import 'bloc/login_bloc.dart';

class LoginForm extends StatefulWidget {
  final UserRepository userRepository;

  const LoginForm({Key key, @required this.userRepository}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repassController = TextEditingController();
  LoginBloc _loginBloc;
  ButtonBloc _buttonBloc;
  UserRepository get userRepo => widget.userRepository;

  bool isEmailValid = true;
  bool isPasswordValid = true;
  bool isRePassValid = true;
  bool isOk = false;
  bool isLogin = true;

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  String get _rePass => _repassController.text;
  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _buttonBloc = BlocProvider.of<ButtonBloc>(context);
    _buttonBloc.add(BStatusChanged(isOk));
    _emailController.addListener(emailChanged);
    _passwordController.addListener(passwordChanged);
    _repassController.addListener(rePassChanged);
    super.initState();
  }

  bool checkIsOk() {
    if (isLogin) {
      return Validators.isValidEmail(_email) &&
          Validators.isValidPassword(_password);
    }
    return Validators.isValidEmail(_email) &&
        Validators.isValidPassword(_password) &&
        _password == _rePass;
  }

  void emailChanged() {
    isEmailValid = Validators.isValidEmail(_email);
    isOk = checkIsOk();
    _buttonBloc.add(BStatusChanged(isOk));
  }

  void passwordChanged() {
    isPasswordValid = Validators.isValidPassword(_password);
    isOk = checkIsOk();
    _buttonBloc.add(BStatusChanged(isOk));
  }

  void rePassChanged() {
    isRePassValid = _password == _rePass;
    isOk = checkIsOk();
    _buttonBloc.add(BStatusChanged(isOk));
  }

  void onLogInButtonPressed() {
    _loginBloc.add(LogInE(email: _email, password: _password));
  }

  void onSingUpButtonPressed() {
    _loginBloc.add(SingUpE(email: _email, password: _password));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      cubit: _loginBloc,
      builder: (context, state) {
        if (state is LSuccesS) {
          return SafeArea(
            child: Center(
              child: Text(AppLocalizations.of(context).succes),
            ),
          );
        }
        if (state is LLoadingS) {
          return SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(AppLocalizations.of(context).loading),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        }
        if (state is LFailureS) {
          return SafeArea(
            child: Center(
              child: Text(AppLocalizations.of(context).failure),
            ),
          );
        }
        if (state is LLoginInitialS) {
          return loginInital();
        }
        if (state is LSingUpInitialS) {
          return singUpInitial();
        }
        if (state is LSettingS) {
          return settingPage();
        }
        return ErrorWidget('No such State');
      },
    );
  }

  Widget settingPage() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).settingthedate,
              style: TextStyle(fontSize: 24),
            )
          ],
        ),
      ),
    );
  }

  Widget loginInital() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Text(
              AppLocalizations.of(context).login,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  labelText: AppLocalizations.of(context).email,
                ),
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.always,
                autocorrect: false,
                validator: (_) {
                  return !isEmailValid
                      ? AppLocalizations.of(context).invalidemail
                      : null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: AppLocalizations.of(context).password,
                ),
                keyboardType: TextInputType.visiblePassword,
                autovalidateMode: AutovalidateMode.always,
                obscureText: true,
                autocorrect: false,
                validator: (_) {
                  return !isPasswordValid
                      ? AppLocalizations.of(context).invalidpassword
                      : null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 0, left: 30, right: 30),
              child: Container(
                width: double.infinity,
                child: BlocBuilder<ButtonBloc, ButtonState>(
                  cubit: _buttonBloc,
                  builder: (context, state) {
                    if (state is ButtonDisabled) {
                      return LoginButton(
                        onPressed: null,
                      );
                    }
                    if (state is ButtonEnabled) {
                      return LoginButton(
                        onPressed: onLogInButtonPressed,
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 0, bottom: 0, left: 30, right: 30),
              child: Container(
                width: double.infinity,
                child: GoogleLoginButton(),
              ),
            ),
            FlatButton(
              onPressed: () {
                isLogin = false;
                _buttonBloc.add(BStatusChanged(false));
                _loginBloc.add(CreateAccountButtonPressedE());
              },
              child: Text(AppLocalizations.of(context).createanaccount),
            )
          ],
        ),
      ),
    );
  }

  Widget singUpInitial() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Text(
              AppLocalizations.of(context).registre,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  labelText: AppLocalizations.of(context).email,
                ),
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.always,
                autocorrect: false,
                validator: (_) {
                  return !isEmailValid
                      ? AppLocalizations.of(context).invalidemail
                      : null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: AppLocalizations.of(context).password,
                ),
                keyboardType: TextInputType.visiblePassword,
                autovalidateMode: AutovalidateMode.always,
                obscureText: true,
                autocorrect: false,
                validator: (_) {
                  return !isPasswordValid
                      ? AppLocalizations.of(context).invalidpassword
                      : null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextFormField(
                controller: _repassController,
                decoration: InputDecoration(
                  icon: Icon(Icons.text_format),
                  labelText: AppLocalizations.of(context).rewritePass,
                ),
                keyboardType: TextInputType.visiblePassword,
                autovalidateMode: AutovalidateMode.always,
                obscureText: true,
                autocorrect: false,
                validator: (_) {
                  return !isRePassValid
                      ? AppLocalizations.of(context).passwordnotsame
                      : null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 0, left: 30, right: 30),
              child: Container(
                width: double.infinity,
                child: BlocBuilder<ButtonBloc, ButtonState>(
                  cubit: _buttonBloc,
                  builder: (context, state) {
                    if (state is ButtonDisabled) {
                      return CreateAnAccountButton(
                        onPressed: null,
                      );
                    }
                    if (state is ButtonEnabled) {
                      return CreateAnAccountButton(
                        onPressed: onSingUpButtonPressed,
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                isLogin = true;
                _buttonBloc.add(BStatusChanged(false));
                _loginBloc.add(SignInButtonPressedE());
              },
              child: Text(AppLocalizations.of(context).singin),
            )
          ],
        ),
      ),
    );
  }
}
