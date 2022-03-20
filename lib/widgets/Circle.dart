import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_note/blocs/bloc_notes/notes_bloc.dart';

class Circle extends StatelessWidget {
  const Circle({
    Key? key,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  final int? color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50.0),
      onTap: onPressed,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: Color(color!),
          shape: BoxShape.circle,
        ),
        child: BlocBuilder<NoteBloc, NoteState>(builder: (_, state) {
          return state.color == color
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : Container();
        }),
      ),
    );
  }
}
