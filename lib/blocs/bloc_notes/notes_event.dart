part of 'notes_bloc.dart';

@immutable
abstract class NoteEvent {}

class AddNote extends NoteEvent {
  final String title;
  final String body;
  final DateTime created;
  final int color;
  final String category;
  final bool isComplete;

  AddNote({
    required this.title,
    required this.body,
    required this.created,
    required this.color,
    required this.category,
    required this.isComplete,
  });
}

class SelectedColorEvent extends NoteEvent {
  final int color;
  SelectedColorEvent(this.color);
}

class SelectedCategoryEvent extends NoteEvent {
  final String category;
  final Color colorCategory;
  SelectedCategoryEvent(this.category, this.colorCategory);
}

class ChangedToGird extends NoteEvent {
  final bool isList;
  ChangedToGird(this.isList);
}

class UpdateNoteEvent extends NoteEvent {
  final String title;
  final String body;
  final DateTime created;
  final int color;
  final String category;
  final bool isComplete;
  final int index;
  UpdateNoteEvent({
    required this.title,
    required this.body,
    required this.category,
    required this.color,
    required this.created,
    required this.isComplete,
    required this.index,
  });
}

class DeleteNote extends NoteEvent {
  final int index;
  DeleteNote(this.index);
}

class InitNote extends NoteEvent {}

class ChangeTheme extends NoteEvent {
  final ThemeData themeData;
  ChangeTheme(this.themeData);
}
