import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_note/blocs/bloc_notes/notes_bloc.dart';
import 'package:keep_note/helpers/modelSelectCategory.dart';

import 'package:keep_note/widgets/SelectColorCategory.dart';
import 'package:keep_note/widgets/TextFieldBody.dart';
import 'package:keep_note/widgets/TextFileTitle.dart';
import 'package:keep_note/widgets/TextTK.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<NoteBloc>(context)
        .add(ChangeTheme(BlocProvider.of<NoteBloc>(context).state.themeData));
    super.initState();
  }

  void clearText() {
    _titleController.clear();
    _bodyController.clear();
  }

  @override
  void dispose() {
    clearText();
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteBloc = BlocProvider.of<NoteBloc>(context);
    final themeBloc = BlocProvider.of<NoteBloc>(context).state.themeData;
    return Scaffold(
      backgroundColor: themeBloc.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: themeBloc.scaffoldBackgroundColor,
        leading: InkWell(
            onTap: () {
              if (_titleController.text.isNotEmpty ||
                  _bodyController.text.isNotEmpty) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: TextTK(
                          text: "Do you really want to cancel?",
                          fontWeight: FontWeight.w600,
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                clearText();
                              },
                              child: Text("YES")),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("NO"))
                        ],
                      );
                    });
              } else {
                Navigator.pop(context);
              }
            },
            child: Center(
              child: TextTK(
                text: "Cancel",
                color: themeBloc.buttonColor,
                fontSize: 16,
              ),
            )),
        title: TextTK(
          text: "Add Note",
          color: themeBloc.canvasColor,
          fontWeight: FontWeight.bold,
          fontSize: 21,
        ),
        actions: [
          InkWell(
            onTap: () {
              noteBloc.add(AddNote(
                title: _titleController.text,
                body: _bodyController.text,
                created: DateTime.now(),
                color: noteBloc.state.color,
                category: noteBloc.state.category,
                isComplete: false,
              ));
              clearText();
              Navigator.pop(context);
            },
            child: Container(
              width: 60,
              alignment: Alignment.center,
              child: TextTK(
                text: "Save",
                color: themeBloc.buttonColor,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              TextFieldTitle(controller: _titleController),
              SizedBox(height: 20.0),
              TextFieldBody(controller: _bodyController),
              SizedBox(height: 20.0),
              _CatagoryList(),
              SizedBox(height: 20),
              SelectColorCategory(),
            ],
          ),
        ),
      )),
    );
  }
}

class _CatagoryList extends StatelessWidget {
  const _CatagoryList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeBloc = BlocProvider.of<NoteBloc>(context).state.themeData;
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: themeBloc.backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextTK(
              text: "Caterogy",
              color: themeBloc.canvasColor,
            ),
          ),
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
              borderRadius: BorderRadius.circular(15.0),
              onTap: () => showBottomSheetCategory(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<NoteBloc, NoteState>(
                      builder: (_, state) {
                        return Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: state.colorCategory,
                                width: 4.0,
                              ),
                              borderRadius: BorderRadius.circular(7.0)),
                        );
                      },
                    ),
                    BlocBuilder<NoteBloc, NoteState>(
                      builder: (_, state) {
                        return TextTK(
                          text: state.category,
                          fontWeight: FontWeight.w600,
                          color: themeBloc.canvasColor,
                        );
                      },
                    ),
                    Icon(Icons.expand_more, color: themeBloc.canvasColor),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Center(
//               child: TextTK(
//                 text: "Cancel",
//                 color: Color(0xff0C6CF2),
//                 fontSize: 16,
//               ),
//             )),