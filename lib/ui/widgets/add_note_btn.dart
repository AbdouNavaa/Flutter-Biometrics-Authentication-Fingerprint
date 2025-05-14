import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/notes_bloc/notes_bloc.dart';
import '../pages/note_form_page.dart';

class AddNoteButton extends StatelessWidget {
  const AddNoteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<NotesBloc>(context),
              child: const NoteFormPage(),
            ),
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
