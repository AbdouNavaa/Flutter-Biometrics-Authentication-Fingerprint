import 'package:biometrics_demo/ui/pages/notes_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/notes_bloc/notes_bloc.dart';
import 'bloc/notes_bloc/notes_event.dart';
import 'bloc/theme_cubit/theme_cubit.dart';
import 'data_sources/notes_local_data_source.dart';
import 'localization/app_localization.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final notesLocalDataSource = NotesLocalDataSource(sharedPreferences);

  // Vérifie si l'utilisateur est déjà authentifié
  final isAuthenticated = sharedPreferences.getBool('isAuthenticated') ?? false;

  runApp(
    MyApp(
      notesLocalDataSource: notesLocalDataSource,
      isAuthenticated: isAuthenticated,
    ),
  );
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);

    // ✅ On sauvegarde le choix de la langue
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', newLocale.languageCode);
  }

  final NotesLocalDataSource notesLocalDataSource;
  final bool isAuthenticated;

  const MyApp({
    super.key,
    required this.notesLocalDataSource,
    required this.isAuthenticated,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('locale');
    if (languageCode != null) {
      setState(() {
        _locale = Locale(languageCode);
      });
    }
  }

  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create:
              (_) =>
                  NotesBloc(widget.notesLocalDataSource)
                    ..add(FetchNotesEvent()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: _locale,
            title: 'Notes App',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            supportedLocales: const [Locale('en', ''), Locale('ar', '')],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale == null) return supportedLocales.first;
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            themeMode: themeMode,
            home: widget.isAuthenticated ? const NotesPage() : const HomePage(),
          );
        },
      ),
    );
  }
}
