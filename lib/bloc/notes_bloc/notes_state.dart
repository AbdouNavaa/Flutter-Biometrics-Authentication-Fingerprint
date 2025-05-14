import 'package:equatable/equatable.dart';
import '../../models/note.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];
}

class NotesInitialState extends NotesState {}

class NotesLoadingState extends NotesState {}

class NotesLoadedState extends NotesState {
  final List<Note> notes;

  const NotesLoadedState(this.notes);

  @override
  List<Object> get props => [notes];
}

class NotesErrorState extends NotesState {
  final String error;

  const NotesErrorState(this.error);

  @override
  List<Object> get props => [error];
}