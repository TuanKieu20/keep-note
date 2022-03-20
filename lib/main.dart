import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:keep_note/blocs/bloc_notes/notes_bloc.dart';
import 'package:keep_note/models/notes_model.dart';

import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteModelAdapter());
  await Hive.openBox<NoteModel>("keepNote");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
    ));
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NoteBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "KeppNote",
        home: BlocBuilder<NoteBloc, NoteState>(builder: (context, state) {
          return HomePage();
        }),
      ),
    );
  }
}
