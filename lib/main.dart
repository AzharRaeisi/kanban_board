import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kanban_board/pages/home_page/home_page.dart';
import 'package:kanban_board/pages/login_page.dart';
import 'package:kanban_board/utils/constants/color_seed.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const App(),
  );
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeMode themeMode = ThemeMode.system;
  ColorSeed colorSelected = ColorSeed.baseColor;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kanban Task Board',
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      themeMode: themeMode,
      theme: ThemeData(
        colorSchemeSeed: colorSelected.color,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: ColorSeed.teal.color,
        brightness: Brightness.dark,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              return HomePage(
                themeMode: themeMode,
                handleColorSelect: (seed) {
                  setState(() {
                    colorSelected = seed;
                  });
                },
                handleBrightnessChange: () {
                  setState(() {
                    themeMode = themeMode == ThemeMode.dark
                        ? ThemeMode.light
                        : ThemeMode.dark;
                  });
                },
              );
            } else {
              return const LoginPage();
            }
          }),
    );
  }
}
