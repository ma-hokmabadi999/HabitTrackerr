// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_import, use_super_parameters, file_names, unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekdays/models/habit/gotHabitProvider.dart';
import 'package:weekdays/views/DateHeader/Dateslider.dart';
import 'package:weekdays/views/HabitsStats/HabitsStats.dart';
import './Habits/showHabits.dart';
import 'Habits/AddOrUpdate/AddOrUpdateHabit.dart';
import 'package:isar/isar.dart';

class HomePage extends StatefulWidget {
  final Isar isar;
  const HomePage({
    Key? key,
    required this.isar,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  DateTime now = DateTime.now();
  List<List> weekDays = [];
  int? selectedIndex;
  DateTime? forFirstDay = DateTime.now();
  DateTime dateHabitList = DateTime.now();
  bool isLoaded = false;
  bool ourcount = false;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        // Navigate to Statistics screen
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => HabitsStats(isar: widget.isar)),
        );
        break;
      case 1:
        // Navigate to Add Habit screen
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => AddOrUpdateHabit(isar: widget.isar)),
        );
        break;

      case 2:
        // Navigate to Settings screen
        // You need to create a Settings screen for this
        break;
    }
  }

  // Add this line to track selected index
  @override
  void initState() {
    super.initState();

    selectedIndex = DateTime.now().weekday + 1;
    selectedIndex = selectedIndex == 7
        ? 0
        : (selectedIndex == 8)
            ? 1
            : selectedIndex;
    print(selectedIndex);
  }

///////////////////////////////////////////
  DateTime getFirstDayOfWeek(DateTime date, int firstDayOfWeek) {
    // Adjust to start the week on a different day
    int dayOffset = date.weekday - firstDayOfWeek;
    if (dayOffset < 0)
      dayOffset += 7; // Correct for weeks starting on days other than Monday

    return date.subtract(Duration(days: dayOffset));
  }

  List<String> dayNamesEN = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  List<String> dayNamesFA = [
    'یکشنبه',
    'دوشنبه',
    'سه شنبه',
    'چهار چشنبه',
    'پنج شنبه',
    'جمعه',
    'شنبه'
  ];

  List<List> getWeekDays(DateTime startingDate) {
    List<List<String>> weekDays = [];

    for (int i = 0; i < 7; i++) {
      DateTime day = startingDate.add(Duration(days: i));
      String dayName = DateFormat('EEEE').format(day); // Getting the day name
      day = DateTime(day.year, day.month, day.day, 0, 0, 0, 0);
      // if (i == 6) {
      //   setForFirstDay(day);
      // }
      String dateString =
          DateFormat('MM/dd/yyyy').format(day); // Formatting the date
      dayName = dayNamesFA[dayNamesEN.indexOf(dayName)];
      weekDays.add([dayName, dateString]);
    }

    return weekDays;
  }

/////////////////////////////////////////////////////////

  void setSelectedIndex(int index) {
    if (selectedIndex != index) {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  void setForFirstDay(DateTime date) {
    if (forFirstDay != date) {
      setState(() {
        forFirstDay = date;
      });
    }
  }

  void setDateHabitList(DateTime date) {
    if (dateHabitList != date) {
      setState(() {
        dateHabitList = date;
      });
      // Assuming you want to set the status to false whenever this method is called
      var counterModel = Provider.of<CounterModel>(context, listen: false);
      if (counterModel.count != ourcount) {
        setState(() {
          ourcount = counterModel.count;
          counterModel.getStatus(false);
        });
      }
      counterModel.getStatus(true);
    }
  }

  void setIsLoaded(bool isloaded) {
    if (isloaded != isLoaded) {
      setState(() {
        isLoaded = isloaded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var counter = Provider.of<CounterModel>(context, listen: false);
    DateTime parsedDate = DateTime(now.year, now.month, now.day);

    DateTime dateWithTimeZero =
        DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "روتین",
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
              fontSize: 30),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 0.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          AddOrUpdateHabit(isar: widget.isar)),
                );
              },
              child: Container(
                margin: EdgeInsets.only(left: 15, right: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(4),
                  color: Color.fromARGB(255, 115, 240, 93),
                ),
                child: Icon(
                  Icons.add,
                  color: Color.fromARGB(255, 18, 86, 150),
                  size: 30,
                ),
                padding: EdgeInsets.all(2),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 130,
              child: weekSlider(
                isar: widget.isar,
                selectedIndex: selectedIndex,
                onDateSelected: setSelectedIndex,
                onFirstDay: setForFirstDay,
                forFirstDay: forFirstDay ?? DateTime.now(),
                getFirstDayOfWeek: getFirstDayOfWeek,
                getWeekDays: getWeekDays,
                setDateHabit: setDateHabitList,
              ),
            ),
            HabitsView(
              isar: widget.isar,
              date: dateHabitList,
              setIsLoaded: setIsLoaded,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, size: 30), // Custom icon size for emphasis
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors
            .amber[800], // Highlight the selected item with a vibrant color
        unselectedItemColor: Colors.grey, // Dull color for unselected items
        onTap: _onItemTapped,
        backgroundColor:
            Colors.deepPurple[400], // A more dynamic background color
        elevation: 20.0, // Higher elevation for a pronounced shadow
        type: BottomNavigationBarType
            .fixed, // Fixed type to accommodate three items
        showUnselectedLabels: true, // Show labels for unselected items
        selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold), // Bold text for selected item
        unselectedLabelStyle:
            TextStyle(fontSize: 12), // Smaller text for unselected items
      ),
    );
  }
}
