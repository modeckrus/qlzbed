import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jiffy/jiffy.dart';

import 'authentication/bloc/authentication_bloc.dart';
import 'bloc_observer.dart';
import 'dark_theme.dart';
import 'localization/lang_codes.dart';
import 'localization/localizations.dart';
import 'perferences/bloc/perferences_bloc.dart';
import 'perferences/setting.dart';
import 'route_generator.dart';
import 'user_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  final UserRepository userRepository = UserRepository();
  // UserRepository(firebaseAuth: FirebaseAuth.instance);
  runApp(BlocProvider(
      create: (context) =>
          AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
      child: BlocProvider(
        create: (context) => PerferencesBloc()..add(PerferencesAppStarted()),
        child: MyApp(
          userRepository: userRepository,
        ),
      )));
}

class MyApp extends StatefulWidget {
  final UserRepository userRepository;
  MyApp({Key key, @required this.userRepository}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Setting setting;
  @override
  Widget build(BuildContext context) {
    return BlocListener<PerferencesBloc, PerferencesState>(
      listener: (context, state) {
        if (state is PerferencesLoading) {}
        if (state is PerferencesLoaded) {
          setState(() {
            setting = state.setting;
          });
        }
      },
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: LangCodes.locales,
        onGenerateTitle: (BuildContext context) {
          Jiffy.locale(Localizations.localeOf(context).languageCode)
              .then((value) {
            print('Jiffy locale setted: ' + value);
          });

          return AppLocalizations.of(context).title;
        },
        themeMode: setting == null ? ThemeMode.system : setting.themeMode,
        // themeMode: ThemeMode.dark,
        darkTheme: MyDartTheme.darkTheme,
        onGenerateRoute: (settings) {
          return RouteGenerator.generateRoute(settings, widget.userRepository);
        },
        initialRoute: '/',
      ),
    );
  }
}
