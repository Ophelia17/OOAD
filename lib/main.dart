import 'package:enono/presentation/Login/bloc/login_bloc.dart';
import 'package:enono/presentation/Login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'package:enono/data/local/local_database_service.dart';
import 'package:enono/core/locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/Landing/landing_screen.dart';
import 'package:enono/presentation/Landing/bloc/landing_bloc.dart';
//it is convention to leave one blank line b/w
//imports of packages and our own files

late LocalStorageService
    localStorageService; //defined here as it has to be a global variable

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //required for LocalStorageService and some other things
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  await Firebase.initializeApp();
  await setupLocator();
  await Geolocator.requestPermission();
  localStorageService = locator<LocalStorageService>();
  await LocalStorageService.getInstance();
  runApp(const BlocApp());
}

class BlocApp extends StatelessWidget {
  const BlocApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Enono',
        home: localStorageService.isLoggedIn == false
            ? (BlocProvider<LoginBloc>(
                create: (_) => LoginBloc(localStorageService),
                child: BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                  return const LoginScreen();
                })))
            : BlocProvider<LandingBloc>(
                create: (_) => LandingBloc(localStorageService),
                child: BlocBuilder<LandingBloc, LandingState>(
                    builder: (context, state) {
                  return LandingScreen(
                    localStorageService: localStorageService,
                    uid: localStorageService.uid,
                  );
                })));
  }
}
