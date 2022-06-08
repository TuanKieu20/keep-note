import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_note/blocs/bloc_notes/notes_bloc.dart';
import 'package:keep_note/widgets/ItemCategory.dart';
import 'package:keep_note/widgets/TextTK.dart';

void showBottomSheetCategory(ctx) {
  final noteBloc = BlocProvider.of<NoteBloc>(ctx);

  showModalBottomSheet(
    // isDismissible: false,
    // enableDrag: false,
    context: ctx,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40.0),
        topRight: Radius.circular(40.0),
      ),
    ),
    builder: (BuildContext context) => Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
        boxShadow: [
          BoxShadow(color: Colors.blue, blurRadius: 10, spreadRadius: -5.0)
        ],
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          TextTK(
            text: "Select Category",
            fontSize: 20,
          ),
          Divider(
            thickness: 3,
          ),
          SizedBox(height: 20),
          ItemCategory(
            onPressed: () {
              noteBloc.add(SelectedCategoryEvent(
                "Personal",
                Colors.blue,
              ));
            },
            color: Colors.blue,
            text: "Personal",
          ),
          ItemCategory(
            onPressed: () {
              noteBloc.add(SelectedCategoryEvent(
                "Friends",
                Colors.green,
              ));
            },
            color: Colors.green,
            text: "Friends",
          ),
          ItemCategory(
            onPressed: () {
              noteBloc.add(SelectedCategoryEvent(
                "Work",
                Colors.red,
              ));
            },
            color: Colors.red,
            text: "Work",
          ),
          ItemCategory(
            onPressed: () {
              noteBloc.add(SelectedCategoryEvent(
                "Family",
                Colors.purple,
              ));
            },
            color: Colors.purple,
            text: "Family",
          ),
        ],
      ),
    ),
  );
}
