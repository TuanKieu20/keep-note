import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_note/blocs/bloc_notes/notes_bloc.dart';

import 'Circle.dart';

class SelectColorCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final noteBloc = BlocProvider.of<NoteBloc>(context);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Circle(
            color: 0xff1977F3,
            onPressed: () {
              noteBloc.add(SelectedColorEvent(0xff1977F3));
            },
          ),
          Circle(
            color: 0xffF44235,
            onPressed: () => noteBloc.add(SelectedColorEvent(0xffF44235)),
          ),
          Circle(
            color: 0xff4CAF50,
            onPressed: () => noteBloc.add(SelectedColorEvent(0xff4CAF50)),
          ),
          Circle(
            color: 0xff0A557F,
            onPressed: () => noteBloc.add(SelectedColorEvent(0xff0A557F)),
          ),
          Circle(
            color: 0xff9C27B0,
            onPressed: () => noteBloc.add(SelectedColorEvent(0xff9C27B0)),
          ),
          Circle(
            color: 0xffE91C63,
            onPressed: () => noteBloc.add(SelectedColorEvent(0xffE91C63)),
          ),
          Circle(
            color: 0xff002091,
            onPressed: () => noteBloc.add(SelectedColorEvent(0xff002091)),
          ),
          Circle(
            color: 0xff009688,
            onPressed: () => noteBloc.add(SelectedColorEvent(0xff009688)),
          ),
        ],
      ),
    );
  }
}
