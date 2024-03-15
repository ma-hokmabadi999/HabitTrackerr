// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:isar/isar.dart';
import 'package:weekdays/models/habit/habit.dart';
import 'package:weekdays/views/Habits/AddOrUpdate/ColorSelector.dart';
import 'package:weekdays/views/Habits/AddOrUpdate/Reminder.dart';
import 'package:weekdays/views/Habits/AddOrUpdate/SavaAndCancel.dart';
import 'package:weekdays/views/Habits/AddOrUpdate/SetDate.dart';
import 'package:weekdays/views/Habits/AddOrUpdate/SetGoalTimeUnit.dart';
import 'package:weekdays/views/Habits/AddOrUpdate/habitName.dart';

import '../../../models/habit/HabitService.dart' show HabitService;
import 'package:intl/intl.dart';

class AddOrUpdateHabit extends StatefulWidget {
  final Isar isar;
  const AddOrUpdateHabit({Key? key, required this.isar}) : super(key: key);

  @override
  State<AddOrUpdateHabit> createState() => _AddOrUpdateHabitState();
}

class _AddOrUpdateHabitState extends State<AddOrUpdateHabit> {
  late final HabitService _habitService;
  late final TextEditingController _habitName;
  late final TextEditingController _goalCount;

  DateTime defaultEndDate = DateFormat("MM/dd/yyyy").parse("01/01/1970");

  void saveHabit() async {
    final habit = Habit()
      ..name = _habitName.text
      ..selectedDays = getSelectedDayNames().join(', ')
      ..color = _selectedColor
      ..goalCount = int.parse(_goalCount.text)
      ..timeUnit = _selectedTimeUnit
      ..startDate = dateMap['startDate']!
      ..endDate = dateMap['endDate'] ?? defaultEndDate
      ..reminderHour = selectedTime.hour
      ..reminderMinute = selectedTime.minute
      ..isReminderClicked = reminderClicked;

    try {
      await _habitService.addHabit(habit, widget.isar);
      Navigator.of(context).pop();
    } catch (e) {
      print('Error saving habit: $e');
    }
  }

  Map<String, DateTime?> dateRange = {
    'startDate': null,
    'endDate': null,
  };

  List<String> colors = [
    '#B71C1C', // Red
    '#880E4F', // Pink
    '#4A148C', // Purple
    '#311B92', // Deep Purple
    '#1A237E', // Indigo
    '#0D47A1', // Blue
    '#01579B', // Light Blue
    '#006064', // Cyan
    '#004D40', // Teal
    '#1B5E20', // Green
    '#33691E', // Light Green
    '#827717', // Lime
    '#F57F17', // Yellow (Darker Amber)
    '#FF6F00', // Amber (Darker Orange)
    '#E65100', // Orange
    '#BF360C', // Deep Orange
    '#3E2723', // Brown
    '#212121', // Grey
    '#263238', // Blue Grey
    '#000000', // Black for extra contrast
    '#2E7D32', // Green 800
    '#C62828', // Red 800
    '#AD1457', // Pink 800
    '#6A1B9A', // Purple 800
    '#283593', // Indigo 800
    '#1565C0', // Blue 800
    '#0277BD', // Light Blue 800
    '#00838F', // Cyan 800
    '#00695C', // Teal 800
    '#9E9D24', // Lime 800
  ];

  String _selectedColor = '#0277BD';
  String _selectedTimeUnit = 'دفعه';

  bool reminderClicked = false;
  TimeOfDay selectedTime = TimeOfDay(hour: 15, minute: 20);

  List<bool> daySelected = List.generate(7, (_) => false);

  void setDaySelected(int index) {
    setState(() {
      daySelected[index] = !daySelected[index];
    });
  }

  List<String> weekDays = [
    'شنبه',
    'یکشنبه',
    'دوشنبه',
    'سه شنبه',
    'چهارشنبه',
    'پنج شنبه',
    'جمعه',
  ];
  Color labelColor = Color.fromARGB(255, 13, 13, 13);

  Map<String, DateTime?> dateMap = {
    'startDate':
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
    'endDate': DateFormat("MM/dd/yyyy").parse("01/01/1970"),
  };

  void _updateDate(String key, DateTime? selectedDate) {
    setState(() {
      dateMap[key] = DateTime(
          selectedDate!.year, selectedDate.month, selectedDate.day, 0, 0, 0, 0);
    });
  }

  List<String> getSelectedDayNames() {
    List<String> selectedDayNames = [];
    for (int i = 0; i < daySelected.length; i++) {
      if (daySelected[i]) {
        selectedDayNames.add(weekDays[i]);
      }
    }
    return selectedDayNames;
  }

  @override
  void initState() {
    // _habitService = HabitService();
    _habitService = HabitService();
    _habitName = TextEditingController();
    _goalCount = TextEditingController(
      text: '1',
    );
    super.initState();
  }

  @override
  void dispose() {
    _habitName.dispose();
    _goalCount.dispose();
    super.dispose();
  }

  void setColor(int index) {
    setState(() {
      _selectedColor =
          colors[index % colors.length]; // Update the selected color
    });
  }

  void setTimeUnit(String timeUnit) {
    setState(() {
      _selectedTimeUnit = timeUnit; // Update the selected time unit
    });
  }

  void setReminderClicked(bool value) {
    setState(() {
      reminderClicked = value ?? false; // Update based on checkbox's value
    });
  }

  void setSelectedTime(TimeOfDay newTime) {
    setState(() {
      selectedTime = newTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtain the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate width and font size based on the screen width
    double textFieldWidth =
        screenWidth - 20; // 40% of screen width for each text field
    double fontSize =
        screenWidth < 600 ? 14 : 16; // Smaller font size for smaller screens

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "ایجاد یا ویرایش روتین",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 12, 12, 12),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                HabitName(
                  fontSize: fontSize,
                  habitName: _habitName,
                  textFieldWidth: textFieldWidth,
                  labelColor: labelColor,
                ),
                ColorSelector(
                  labelColor: labelColor,
                  colors: colors,
                  selectedColor: _selectedColor,
                  textFieldWidth: textFieldWidth,
                  setSelectedColor: setColor,
                ),
                SetGoalTimeUnit(
                  labelColor: labelColor,
                  textFieldWidth: textFieldWidth,
                  goalCount: _goalCount,
                  fontSize: fontSize,
                  selectedTimeUnit: _selectedTimeUnit,
                  setTimeUnit: setTimeUnit,
                ),
                Reminder(
                  reminderClicked: reminderClicked,
                  textFieldWidth: textFieldWidth,
                  labelColor: labelColor,
                  selectedTime: selectedTime,
                  weekDays: weekDays,
                  daySelected: daySelected,
                  setReminderClick: setReminderClicked,
                  setSelectedTime: setSelectedTime,
                  setDaySelected: setDaySelected,
                ),
                SetDate(
                    labelColor: labelColor,
                    dateMap: dateMap,
                    updateDate: _updateDate),
                SaveAndCancel(saveHabit: saveHabit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
