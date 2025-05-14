import 'package:biometrics_demo/driver.dart';
import 'package:biometrics_demo/localization/app_localization.dart';
import 'package:biometrics_demo/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/notes_bloc/notes_bloc.dart';
import '../../bloc/notes_bloc/notes_state.dart';
import '../../bloc/theme_cubit/theme_cubit.dart';
import '../../main.dart';
import '../../resources/app_strings.dart';
import '../widgets/add_note_btn.dart';
import '../widgets/notes_list.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (ctx) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr(AppStrings.notes)),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              // ✅ On bascule entre Anglais et Arabe
              Locale newLocale =
                  Localizations.localeOf(context).languageCode == 'en'
                      ? const Locale('ar')
                      : const Locale('en');
              MyApp.setLocale(context, newLocale);
            },
          ),
          IconButton(
            icon: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                return Icon(
                  themeMode == ThemeMode.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                );
              },
            ),
            onPressed: () {
              BlocProvider.of<ThemeCubit>(context).toggleTheme();
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => _logout(context),
        ),
      ),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is NotesLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotesLoadedState) {
            return NotesList(notes: state.notes);
          } else if (state is NotesErrorState) {
            return Center(child: Text(state.error));
          } else {
            return const Center(child: Text('No notes available.'));
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DriverTrackingPage(),
                    ),
                  );
                },
                child: Icon(Icons.map_outlined),
              ),
            ),
            AddNoteButton(),
          ],
        ),
      ),
    );
  }
}
