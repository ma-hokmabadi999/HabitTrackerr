// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekdays/models/habit/HabitService.dart';
import 'package:weekdays/models/habit/gotHabitProvider.dart';
import 'package:weekdays/models/showhabit/showhabit.dart';
// import 'package:weekdays/views/HomePage.dart';
import 'package:weekdays/views/DateHeader/Dateslider.dart';
// main home page
import 'views/HomePage.dart';
//////
import 'views/Habits/AddOrUpdateHabit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:weekdays/models/habit/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationSupportDirectory();
  final isar =
      await Isar.open([HabitSchema, ShowHabitSchema], directory: dir.path);
  // Initialize HabitService with Isar
  // Create the stream of habits

  runApp(
    ChangeNotifierProvider(
      create: (context) => CounterModel(),
      child: MyApp(
        isar: isar,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Isar isar; // Assuming Habit is your model class

  const MyApp({
    Key? key,
    required this.isar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit Tracker',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('fa', ''), // English
        // Locale('es'), // Spanish
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(
              255, 243, 152, 33), // Setting the AppBar color to blue
        ),
        fontFamily: 'Vazir',
      ),

      // home: const DateItems(),
      // home: HomePage(isar: isar),
      home: HomePage(
        isar: isar,
      ),
    );
  }
}
