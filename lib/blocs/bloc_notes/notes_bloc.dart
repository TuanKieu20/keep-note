import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:keep_note/models/notes_model.dart';
import 'package:keep_note/widgets/ThemeNotes.dart';
part 'notes_event.dart';
part 'notes_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc() : super(NoteState(themeData: ThemeNotes.lightTheme));
  @override
  Stream<NoteState> mapEventToState(NoteEvent event) async* {
    if (event is AddNote) {
      var box = await Hive.openBox<NoteModel>("keepNote");
      var noteModel = NoteModel(
        title: event.title,
        body: event.body,
        color: state.color,
        isComplete: event.isComplete,
        created: DateTime.now(),
        category: event.category,
      );
      box.add(noteModel);
    } else if (event is SelectedColorEvent) {
      yield state.copyWith(color: event.color);
    } else if (event is SelectedCategoryEvent) {
      yield state.copyWith(
        category: event.category,
        colorCategory: event.colorCategory,
      );
    } else if (event is ChangedToGird) {
      yield state.copyWith(isList: event.isList);
    } else if (event is UpdateNoteEvent) {
      var box = await Hive.openBox<NoteModel>("keepNote");
      var noteModel = NoteModel(
          title: event.title,
          body: event.body,
          color: state.color,
          isComplete: event.isComplete,
          category: event.category,
          created: DateTime.now());
      box.putAt(event.index, noteModel);
    } else if (event is DeleteNote) {
      var box = await Hive.openBox<NoteModel>("keepNote");
      box.deleteAt(event.index);
    } else if (event is InitNote) {
      yield NoteState(themeData: ThemeNotes.lightTheme);
    } else if (event is ChangeTheme) {
      yield state.copyWith(themeData: event.themeData);
    }
  }
}
