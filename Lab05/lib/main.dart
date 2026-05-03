import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'providers/note_provider.dart';
import 'screens/home_page.dart';

void main()
{
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb)
  {
    databaseFactory = databaseFactoryFfiWeb;
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => NoteProvider()..loadNotes(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  static const Color backgroundColor = Color(0xFFF5F7FB);
  static const Color primaryColor = Color(0xFF111827);

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'Smart Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
        ),
        fontFamily: 'Arial',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}