import 'package:equatable/equatable.dart';
import '../../models/note.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class FetchNotesEvent extends NotesEvent {}

class AddNoteEvent extends NotesEvent {
  final Note note;

  const AddNoteEvent(this.note);

  @override
  List<Object> get props => [note];
}

class UpdateNoteEvent extends NotesEvent {
  final int index;
  final Note updatedNote;

  const UpdateNoteEvent(this.index, this.updatedNote);

  @override
  List<Object> get props => [index, updatedNote];
}

class DeleteNoteEvent extends NotesEvent {
  final int index;

  const DeleteNoteEvent(this.index);

  @override
  List<Object> get props => [index];
}