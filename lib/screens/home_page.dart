import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:keep_note/blocs/bloc_notes/notes_bloc.dart';
import 'package:keep_note/models/notes_model.dart';
import 'package:keep_note/screens/add_page.dart';
import 'package:keep_note/screens/show_note_page.dart';
import 'package:keep_note/widgets/TextTK.dart';
import 'package:keep_note/widgets/ThemeNotes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var box = Hive.box<NoteModel>("keepNote");
  bool isListView = true;
  bool _isDarkMode = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final noteBloc = BlocProvider.of<NoteBloc>(context);
    final themeBloc = BlocProvider.of<NoteBloc>(context).state.themeData;
    return Scaffold(
      backgroundColor: themeBloc.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: themeBloc.scaffoldBackgroundColor,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            noteBloc.add(ChangedToGird(isListView));
            isListView = !isListView;
          },
          icon: BlocBuilder<NoteBloc, NoteState>(
            builder: (_, state) {
              return state.isList
                  ? Icon(
                      Icons.table_rows,
                      color: themeBloc.canvasColor,
                    )
                  : Icon(
                      Icons.grid_view_rounded,
                      color: themeBloc.canvasColor,
                    );
            },
          ),
        ),
        title: Text(
          "Keep Note",
          style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w500,
              color: themeBloc.canvasColor),
        ),
        actions: [
          Switch(
            value: _isDarkMode,
            onChanged: (value) {
              _isDarkMode = value;
              if (_isDarkMode) {
                noteBloc.add(ChangeTheme(ThemeNotes.darkTheme));
              } else {
                noteBloc.add(ChangeTheme(ThemeNotes.lightTheme));
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (_, Box box, __) {
            if (box.values.isEmpty) {
              // print(box.get("title"));
              return Center(
                child: TextTK(
                  text: "Without Notes",
                  color: themeBloc.buttonColor,
                ),
              );
            }
            return BlocBuilder<NoteBloc, NoteState>(
              builder: (context, state) {
                return state.isList
                    ? ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        itemCount: box.values.length,
                        itemBuilder: (_, index) {
                          NoteModel notes = box.getAt(index);
                          return BlocBuilder<NoteBloc, NoteState>(
                            builder: (_, state) {
                              return state.isList
                                  ? _ListNotes(note: notes, index: index)
                                  : _GridViewNote(note: notes, index: index);
                            },
                          );
                        },
                      )
                    : GridView.builder(
                        itemCount: box.values.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 2 / 2,
                            crossAxisSpacing: 10,
                            mainAxisExtent: 250),
                        itemBuilder: (_, index) {
                          NoteModel note = box.getAt(index);
                          return BlocBuilder<NoteBloc, NoteState>(
                              builder: (_, state) {
                            return state.isList
                                ? _ListNotes(note: note, index: index)
                                : _GridViewNote(note: note, index: index);
                          });
                        });
              },
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Scaffold(body: AddPage())));
        },
        borderRadius: BorderRadius.circular(50),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: themeBloc.buttonColor,
            boxShadow: [
              BoxShadow(color: Colors.blue, blurRadius: 10, spreadRadius: -5.0)
            ],
          ),
          width: 50,
          height: 50,
          child: Icon(Icons.add, color: themeBloc.backgroundColor),
        ),
      ),
    );
  }
}

class _ListNotes extends StatelessWidget {
  final NoteModel note;
  final int index;
  const _ListNotes({required this.note, required this.index});

  String getTimeString(date) {
    final dateTime = DateTime.parse(date);
    final format = DateFormat("dd-MM-yyyy hh:mm a");
    return format.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final noteBloc = BlocProvider.of<NoteBloc>(context);
    final themeBloc = BlocProvider.of<NoteBloc>(context).state.themeData;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return ShowNotePage(index: index, noteModel: note);
        }));
      },
      child: Dismissible(
        key: UniqueKey(),
        background: Container(),
        direction: DismissDirection.endToStart,
        secondaryBackground: Container(
          padding: EdgeInsets.only(right: 35.0),
          margin: EdgeInsets.only(bottom: 15.0),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: Color(note.color!),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: Icon(
            Icons.delete_sweep_rounded,
            color: Colors.white,
            size: 40,
          ),
        ),
        onDismissed: (direction) => noteBloc.add(DeleteNote(index)),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.only(bottom: 15.0),
              height: 135,
              width: size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: themeBloc.backgroundColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextTK(
                          text: note.title.toString().inCaps,
                          fontWeight: FontWeight.w600,
                          textOverflow: TextOverflow.ellipsis,
                          color: themeBloc.canvasColor,
                        ),
                      ),
                      TextTK(
                          text: note.category!,
                          fontSize: 16,
                          color: themeBloc.primaryColor),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Wrap(
                    children: [
                      TextTK(
                        text: note.body.toString().inCaps,
                        fontSize: 16,
                        color: Colors.grey,
                        textOverflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextTK(
                          text: getTimeString(note.created.toString()),
                          fontSize: 16,
                          color: Colors.grey),
                      Tooltip(
                        message: "Select when you complete it",
                        child: Checkbox(
                            fillColor: MaterialStateColor.resolveWith(
                              (states) {
                                if (states.contains(MaterialState.selected)) {
                                  return themeBloc
                                      .buttonColor; // the color when checkbox is selected;
                                }
                                return themeBloc
                                    .canvasColor; //the color when checkbox is unselected;
                              },
                            ),
                            checkColor: themeBloc.scaffoldBackgroundColor,
                            activeColor: themeBloc.buttonColor,
                            value: note.isComplete,
                            onChanged: (value) {
                              noteBloc.add(
                                UpdateNoteEvent(
                                  title: note.title!,
                                  body: note.body!,
                                  category: note.category!,
                                  color: note.color!,
                                  created: note.created!,
                                  isComplete: value!,
                                  index: index,
                                ),
                              );
                            }),
                      ),
                    ],
                  )
                ],
              ),
            ),
            (note.isComplete == true)
                ? Positioned(
                    right: 100,
                    top: -21,
                    child: RotationTransition(
                      turns: AlwaysStoppedAnimation(30 / 360),
                      child: Container(
                        margin: const EdgeInsets.only(top: 25.0),
                        alignment: Alignment.centerRight,
                        width: 110,
                        decoration: BoxDecoration(
                          color: Colors.red,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Text("Completed"),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class _GridViewNote extends StatelessWidget {
  final NoteModel note;
  final int index;

  const _GridViewNote({required this.note, required this.index});

  String getTimeString(date) {
    final dateTime = DateTime.parse(date);
    final format = DateFormat('dd-MM-yyyy ');

    return format.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final noteBloc = BlocProvider.of<NoteBloc>(context);
    final themeBloc = BlocProvider.of<NoteBloc>(context).state.themeData;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return ShowNotePage(index: index, noteModel: note);
        }));
      },
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.up,
        background: Container(),
        secondaryBackground: Container(
          padding: EdgeInsets.only(bottom: 35.0),
          margin: EdgeInsets.only(bottom: 15.0),
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
              color: Color(note.color!),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0))),
          child: Icon(Icons.delete, color: Colors.white, size: 40),
        ),
        onDismissed: (direction) => noteBloc.add(DeleteNote(index)),
        child: Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(bottom: 15.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: themeBloc.backgroundColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextTK(
                text: note.title.toString().inCaps,
                fontWeight: FontWeight.w600,
                textOverflow: TextOverflow.ellipsis,
                color: themeBloc.canvasColor,
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: Container(
                  child: TextTK(
                    text: note.body.toString().inCaps,
                    fontSize: 16,
                    color: themeBloc.primaryColor,
                    textOverflow: TextOverflow.ellipsis,
                    maxLine: 8,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextTK(
                      text: getTimeString(note.created.toString()),
                      fontSize: 16,
                      color: themeBloc.primaryColor),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.circle,
                          color: Color(note.color!), size: 15)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Container(
//             width: 100,
//             padding: const EdgeInsets.symmetric(vertical: 10),
//             decoration: BoxDecoration(
//               color: Colors.transparent,
//               borderRadius: BorderRadius.circular(30),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 50,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(30),
//                         bottomLeft: Radius.circular(30)),
//                   ),
//                   child: IconButton(
//                     color: Colors.black,
//                     highlightColor: Colors.transparent,
//                     splashColor: Colors.transparent,
//                     icon: Icon(Icons.wb_sunny_outlined),
//                     onPressed: () =>
//                         noteBloc.add(ChangeTheme(ThemeNotes.lightTheme)),
//                   ),
//                 ),
//                 Container(
//                   width: 50,
//                   decoration: BoxDecoration(
//                     color: Colors.black,
//                     borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(30),
//                         bottomRight: Radius.circular(30)),
//                   ),
//                   child: IconButton(
//                     highlightColor: Colors.transparent,
//                     splashColor: Colors.transparent,
//                     icon: Icon(
//                       Icons.nights_stay_outlined,
//                       color: Colors.white,
//                     ),
//                     onPressed: () =>
//                         noteBloc.add(ChangeTheme(ThemeNotes.darkTheme)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
