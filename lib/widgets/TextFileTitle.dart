import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_note/blocs/bloc_notes/notes_bloc.dart';

class TextFieldTitle extends StatelessWidget {
  final TextEditingController controller;
  TextFieldTitle({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final themeBloc = BlocProvider.of<NoteBloc>(context).state.themeData;
    return Container(
      decoration: BoxDecoration(
        color: themeBloc.backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.getFont("Inter").copyWith(
          color: themeBloc.canvasColor,
        ),
        decoration: InputDecoration(
          hintText: "Title",
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 10.0),
          hintStyle: TextStyle(
            color: themeBloc.canvasColor,
          ),
        ),
      ),
    );
  }
}
