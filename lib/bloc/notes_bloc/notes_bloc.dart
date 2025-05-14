import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data_sources/notes_local_data_source.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesLocalDataSource notesLocalDataSource;

  NotesBloc(this.notesLocalDataSource) : super(NotesInitialState()) {
    on<FetchNotesEvent>(_onFetchNotes);
    on<AddNoteEvent>(_onAddNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
  }

  Future<void> _onFetchNotes(
      FetchNotesEvent event, Emitter<NotesState> emit) async {
    emit(NotesLoadingState());
    try {
      final notes = await notesLocalDataSource.fetchNotes();
      emit(NotesLoadedState(notes));
    } catch (e) {
      emit(NotesErrorState('Failed to load notes: ${e.toString()}'));
    }
  }

  Future<void> _onAddNote(AddNoteEvent event, Emitter<NotesState> emit) async {
    try {
      await notesLocalDataSource.addNote(event.note);
      add(FetchNotesEvent());
    } catch (e) {
      emit(NotesErrorState('Failed to add note: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateNote(
      UpdateNoteEvent event, Emitter<NotesState> emit) async {
    try {
      await notesLocalDataSource.updateNote(event.index, event.updatedNote);
      add(FetchNotesEvent());
    } catch (e) {
      emit(NotesErrorState('Failed to update note: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteNote(
      DeleteNoteEvent event, Emitter<NotesState> emit) async {
    try {
      await notesLocalDataSource.deleteNote(event.index);
      add(FetchNotesEvent());
    } catch (e) {
      emit(NotesErrorState('Failed to delete note: ${e.toString()}'));
    }
  }
}
