import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_note/blocs/bloc_notes/notes_bloc.dart';
import 'package:keep_note/helpers/modelSelectCategory.dart';
import 'package:keep_note/models/notes_model.dart';
import 'package:keep_note/widgets/SelectColorCategory.dart';
import 'package:keep_note/widgets/TextFieldBody.dart';
import 'package:keep_note/widgets/TextFileTitle.dart';
import 'package:keep_note/widgets/TextTK.dart';

class ShowNotePage extends StatefulWidget {
  const ShowNotePage({Key? key, required this.index, required this.noteModel})
      : super(key: key);

  final int index;
  final NoteModel noteModel;
  @override
  _ShowNotePageState createState() => _ShowNotePageState();
}

class _ShowNotePageState extends State<ShowNotePage> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    _titleController = TextEditingController(
        text: widget.noteModel.title!.capitalizeFirstofEach);
    _bodyController =
        TextEditingController(text: widget.noteModel.body!.inCaps);
    BlocProvider.of<NoteBloc>(context)
        .add(SelectedColorEvent(widget.noteModel.color!));
    BlocProvider.of<NoteBloc>(context).add(SelectedCategoryEvent(
        widget.noteModel.category!,
        BlocProvider.of<NoteBloc>(context).state.colorCategory));
    super.initState();
  }

  @override
  void dispose() {
    clearText();
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void clearText() {
    _titleController.clear();
    _bodyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final noteBloc = BlocProvider.of<NoteBloc>(context);
    final themeBloc = BlocProvider.of<NoteBloc>(context).state.themeData;
    return Scaffold(
      backgroundColor: themeBloc.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: themeBloc.scaffoldBackgroundColor,
        centerTitle: true,
        leadingWidth: 100,
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: themeBloc.buttonColor,
          ),
          label: TextTK(
            text: "Back",
            fontSize: 16,
            color: themeBloc.buttonColor,
          ),
        ),
        title: TextTK(
          text: widget.noteModel.title!.capitalizeFirstofEach,
          color: themeBloc.canvasColor,
          fontSize: 21,
          fontWeight: FontWeight.w600,
          textOverflow: TextOverflow.ellipsis,
        ),
        actions: [
          InkWell(
            onTap: () {
              noteBloc.add(
                UpdateNoteEvent(
                  title: _titleController.text,
                  body: _bodyController.text,
                  category: noteBloc.state.category,
                  color: noteBloc.state.color,
                  created: DateTime.now(),
                  isComplete: false,
                  index: widget.index,
                ),
              );
              clearText();
              Navigator.pop(context);
            },
            child: Container(
              width: 80,
              alignment: Alignment.center,
              child: TextTK(
                text: "Save",
                color: themeBloc.buttonColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                TextFieldTitle(controller: _titleController),
                SizedBox(height: 20),
                TextFieldBody(controller: _bodyController),
                SizedBox(height: 20),
                _Category(),
                SizedBox(height: 20),
                SelectColorCategory(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Category extends StatelessWidget {
  const _Category({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeBloc = BlocProvider.of<NoteBloc>(context).state.themeData;
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeBloc.backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: TextTK(
            text: "Category",
            color: themeBloc.canvasColor,
          ),
        ),
        Spacer(),
        Container(
          width: 170,
          height: 40,
          decoration: BoxDecoration(
              color: themeBloc.backgroundColor,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: themeBloc.buttonColor,
                  blurRadius: 7,
                  spreadRadius: -5,
                )
              ]),
          child: InkWell(
            onTap: () => showBottomSheetCategory(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                BlocBuilder<NoteBloc, NoteState>(builder: (_, state) {
                  return Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        width: 4,
                        color: state.colorCategory,
                      ),
                    ),
                  );
                }),
                BlocBuilder<NoteBloc, NoteState>(builder: (_, state) {
                  return TextTK(
                    text: state.category,
                    fontWeight: FontWeight.w600,
                    color: themeBloc.canvasColor,
                  );
                }),
                Icon(
                  Icons.expand_more,
                  color: themeBloc.canvasColor,
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
