part of 'notes_bloc.dart';

@immutable
class NoteState {
  final int color;
  final String category;
  final Color colorCategory;
  final bool isList;
  final ThemeData themeData;
  const NoteState({
    this.color = 0xff1977F3,
    this.category = "No List",
    this.colorCategory = Colors.grey,
    this.isList = true,
    required this.themeData,
  });

  NoteState copyWith(
      {int? color,
      String? category,
      Color? colorCategory,
      bool? isList,
      ThemeData? themeData}) {
    return NoteState(
      color: color ?? this.color,
      category: category ?? this.category,
      colorCategory: colorCategory ?? this.colorCategory,
      isList: isList ?? this.isList,
      themeData: themeData ?? this.themeData,
    );
  }
}
