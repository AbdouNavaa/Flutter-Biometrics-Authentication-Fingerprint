import 'package:biometrics_demo/localization/app_localization.dart';
import 'package:biometrics_demo/resources/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/notes_bloc/notes_bloc.dart';
import '../../bloc/notes_bloc/notes_event.dart';
import '../../models/note.dart';
import '../widgets/note_form.dart';

class NoteFormPage extends StatelessWidget {
  final Note? existingNote;
  final int? noteIndex;

  const NoteFormPage({super.key, this.existingNote, this.noteIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          existingNote == null
              ? context.tr(AppStrings.addNote)
              : context.tr(AppStrings.editNote),
        ),
      ),
      body: NoteForm(
        existingNote: existingNote,
        onSave: (note) {
          if (existingNote == null) {
            BlocProvider.of<NotesBloc>(context).add(AddNoteEvent(note));
          } else {
            BlocProvider.of<NotesBloc>(
              context,
            ).add(UpdateNoteEvent(noteIndex!, note));
          }
          Navigator.pop(context);
        },
      ),
    );
  }
}
