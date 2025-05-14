import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/notes_bloc/notes_bloc.dart';
import '../../bloc/notes_bloc/notes_event.dart';
import '../../models/note.dart';
import '../pages/note_form_page.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  final int index;

  const NoteItem({super.key, required this.note, required this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(note.title),
      subtitle: Text(note.content),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider.value(
                        value: BlocProvider.of<NotesBloc>(context),
                        child: NoteFormPage(
                          existingNote: note,
                          noteIndex: index,
                        ),
                      ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              BlocProvider.of<NotesBloc>(context).add(DeleteNoteEvent(index));
            },
          ),
        ],
      ),
    );
  }
}
