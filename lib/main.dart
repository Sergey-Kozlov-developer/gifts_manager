import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifts_manager/presentation/login/view/login_page.dart';
import 'package:gifts_manager/presentation/splash/view/splash_page.dart';
import 'package:gifts_manager/presentation/theme/dark_theme.dart';
import 'package:gifts_manager/presentation/theme/light_theme.dart';
import 'package:gifts_manager/simple_bloc_observer.dart';

void main() {
  BlocOverrides.runZoned(
        () => runApp(const MyApp()),
    blocObserver: SimpleBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // lightTheme and darkTheme наши созданные темы
      theme: lightTheme,
      darkTheme: darkTheme,
      // themeMode: ThemeMode.dark,
      home: const SplashPage(), // авторизован или нет
    );
  }
}
