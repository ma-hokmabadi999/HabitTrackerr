// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekdays/Providers/Navigation.dart';
import 'package:weekdays/constants/navigationBar.dart';
import 'package:weekdays/models/habit/HabitService.dart';
import 'package:weekdays/models/habit/gotHabitProvider.dart';
import 'package:weekdays/models/showhabit/showhabit.dart';
// import 'package:weekdays/views/HomePage.dart';
import 'package:weekdays/views/DateHeader/Dateslider.dart';
import 'package:weekdays/views/HabitsStats/HabitsStats.dart';
// main home page
import 'views/HomePage.dart';
//////
import 'views/Habits/AddOrUpdate/AddOrUpdateHabit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:weekdays/models/habit/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'constants/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationSupportDirectory();
  final isar =
      await Isar.open([HabitSchema, ShowHabitSchema], directory: dir.path);
  // Initialize HabitService with Isar
  // Create the stream of habits

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CounterModel()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
      ],
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

  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePageRoute:
        return NoAnimationMaterialPageRoute(
          builder: (_) => HomePage(isar: isar),
          settings: settings,
        );
      case createOrUpdateHabitRoute:
        return NoAnimationMaterialPageRoute(
          builder: (_) => AddOrUpdateHabit(isar: isar),
          settings: settings,
        );
      case habitStats:
        return NoAnimationMaterialPageRoute(
          builder: (_) => HabitsStats(isar: isar),
          settings: settings,
        );
      default:
        // Fallback for unknown routes
        return MaterialPageRoute(builder: (_) => HomePage(isar: isar));
    }
  }

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
      supportedLocales: const [
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
      onGenerateRoute: _generateRoute,
    );
  }
}
