import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';

class NotesLocalDataSource {
  static const _notesKey = 'notes';

  final SharedPreferences _sharedPreferences;

  NotesLocalDataSource(this._sharedPreferences);

  Future<List<Note>> fetchNotes() async {
    final notesString = _sharedPreferences.getString(_notesKey);
    if (notesString == null || notesString.isEmpty) {
      return [];
    }
    final List<dynamic> notesJson = jsonDecode(notesString);
    return notesJson.map((json) => Note.fromJson(json)).toList();
  }

  Future<bool> addNote(Note note) async {
    final notes = await fetchNotes();
    notes.add(note);
    return await _saveNotes(notes);
  }

  Future<bool> updateNote(int index, Note updatedNote) async {
    final notes = await fetchNotes();
    if (index < 0 || index >= notes.length) {
      return false;
    }
    notes[index] = updatedNote;
    return await _saveNotes(notes);
  }

  Future<bool> deleteNote(int index) async {
    final notes = await fetchNotes();
    if (index < 0 || index >= notes.length) {
      return false;
    }
    notes.removeAt(index);
    return await _saveNotes(notes);
  }

  Future<bool> _saveNotes(List<Note> notes) async {
    final notesJson = notes.map((note) => note.toJson()).toList();
    final notesString = jsonEncode(notesJson);
    return await _sharedPreferences.setString(_notesKey, notesString);
  }
}
