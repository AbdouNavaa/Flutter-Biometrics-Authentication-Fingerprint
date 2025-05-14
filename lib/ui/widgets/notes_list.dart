import 'package:flutter/material.dart';
import '../../models/note.dart';
import 'note_item.dart';

class NotesList extends StatelessWidget {
  final List<Note> notes;

  const NotesList({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return NoteItem(note: notes[index], index: index);
      },
    );
  }
}
