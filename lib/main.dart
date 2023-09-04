import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:keep_notes_app/models/hive_db.dart';
import 'package:keep_notes_app/providers/create_note_provider.dart';
import 'package:keep_notes_app/providers/landing_page_provider.dart';
import 'package:keep_notes_app/screens/create_note.dart';
import 'package:keep_notes_app/screens/landing_page.dart';
import 'package:keep_notes_app/utils/global_variables.dart';
import 'package:keep_notes_app/utils/network_connectivity_service.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(NotesModelAdapter());
  await Hive.openBox("notes");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> AddNoteProvider()),
        ChangeNotifierProvider(create: (_)=> LandingPageProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Google Keep Notes Clone',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LandingPage(),
      ),
    );
  }
}
