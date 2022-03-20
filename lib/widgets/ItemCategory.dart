import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_note/blocs/bloc_notes/notes_bloc.dart';
import 'package:keep_note/widgets/TextTK.dart';

class ItemCategory extends StatelessWidget {
  const ItemCategory(
      {Key? key,
      required this.onPressed,
      required this.color,
      required this.text})
      : super(key: key);

  final VoidCallback? onPressed;
  final Color? color;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        margin: const EdgeInsets.only(bottom: 15.0),
        child: Row(
          children: [
            Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: color!,
                        width: 4.0,
                      ),
                      borderRadius: BorderRadius.circular(7.0)),
                ),
                SizedBox(width: 10.0),
                TextTK(text: text!),
              ],
            ),
            Spacer(),
            Row(
              children: [
                Container(
                  child: BlocBuilder<NoteBloc, NoteState>(builder: (_, state) {
                    return state.category == text
                        ? Icon(
                            Icons.check,
                            color: state.colorCategory,
                          )
                        : Container();
                  }),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
