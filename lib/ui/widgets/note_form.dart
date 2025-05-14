import 'package:biometrics_demo/localization/app_localization.dart';
import 'package:biometrics_demo/resources/app_strings.dart';
import 'package:flutter/material.dart';
import '../../models/note.dart';

class NoteForm extends StatefulWidget {
  final Note? existingNote;
  final void Function(Note note) onSave;

  const NoteForm({super.key, this.existingNote, required this.onSave});

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;

  @override
  void initState() {
    super.initState();
    _title = widget.existingNote?.title ?? '';
    _content = widget.existingNote?.content ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              initialValue: _title,
              decoration: InputDecoration(
                labelText: context.tr(AppStrings.noteTitle),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.tr(AppStrings.noteTitleEmpty);
                }
                return null;
              },
              onSaved: (value) {
                _title = value!;
              },
            ),
            TextFormField(
              initialValue: _content,
              decoration: InputDecoration(
                labelText: context.tr(AppStrings.noteContent),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.tr(AppStrings.noteContentEmpty);
                }
                return null;
              },
              onSaved: (value) {
                _content = value!;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final note = Note(
                    id: widget.existingNote?.id ?? DateTime.now().toString(),
                    title: _title,
                    content: _content,
                  );
                  widget.onSave(note);
                }
              },
              child: Text(
                widget.existingNote == null
                    ? context.tr(AppStrings.addNote)
                    : context.tr(AppStrings.editNote),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
