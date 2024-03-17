// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_import, use_super_parameters, file_names, unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:persian_tools/persian_tools.dart';
import 'package:provider/provider.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:weekdays/constants/navigationBar.dart';
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

  String getShamsi(DateTime date) {
    Jalali jalaliDate = Jalali.fromDateTime(date);

    // Find today's date in Jalali
    Jalali today = Jalali.now();

    // Find yesterday and tomorrow in Jalali
    Jalali yesterday = today.addDays(-1);
    Jalali tomorrow = today.addDays(1);

    String formattedDate = "";

    // Check if the date is today, yesterday, or tomorrow
    if (jalaliDate.year == today.year &&
        jalaliDate.month == today.month &&
        jalaliDate.day == today.day) {
      formattedDate = 'امروز';
    } else if (jalaliDate.year == yesterday.year &&
        jalaliDate.month == yesterday.month &&
        jalaliDate.day == yesterday.day) {
      formattedDate = 'دیروز';
    } else if (jalaliDate.year == tomorrow.year &&
        jalaliDate.month == tomorrow.month &&
        jalaliDate.day == tomorrow.day) {
      formattedDate = 'فردا';
    } else {
      // Otherwise, return the formatted Jalali date
      formattedDate =
          "${convertEnToFa(jalaliDate.day.toString())} ${jalaliDate.formatter.mN}";
    }
    return formattedDate;
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'تنظیمات':
        // Navigate to Settings Page
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => SettingsPage()));
        break;
      case 'آنالیز':
        // Navigate to HabitsStats Page
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HabitsStats(isar: widget.isar)));
        break;
      // Add more cases as needed
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
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(222, 222, 222, 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      getShamsi(dateHabitList),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 90,
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
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
