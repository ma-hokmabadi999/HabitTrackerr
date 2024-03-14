// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:isar/isar.dart';
import 'package:weekdays/models/habit/habit.dart';
import 'date_selection_button.dart';

import '../../models/habit/HabitService.dart' show HabitService;
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
                Container(
                  margin: EdgeInsets.only(bottom: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8, right: 3),
                        child: Text(
                          "نام روتین",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: labelColor),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: SizedBox(
                              width: textFieldWidth - 10,
                              height: 40,
                              child: TextField(
                                controller: _habitName,
                                enableSuggestions: false,
                                autocorrect: false,
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 20, 20,
                                      20), // Set text color to white
                                  fontSize: fontSize,
                                ),
                                decoration: InputDecoration(
                                    hintText: 'نام عادت را وارد کنید',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintStyle: TextStyle(
                                      color: Color.fromARGB(205, 86, 84, 84),
                                      fontSize: fontSize, // Adjusted font size
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 8, right: 3),
                        child: Text(
                          "انتخاب رنگ",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: labelColor),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: EdgeInsets.all(10),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: colors.length, // Number of colors
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        8, // Increase for more columns, making items smaller
                                    childAspectRatio:
                                        1, // Aspect ratio of 1 keeps items square
                                    crossAxisSpacing:
                                        10, // Reduce spacing for smaller items
                                    mainAxisSpacing:
                                        10, // Reduce spacing for smaller items
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    // Example color list, replace with your own list of colors

                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedColor = colors[index %
                                              colors
                                                  .length]; // Update the selected color
                                        });
                                        Navigator.pop(
                                            context); // Close the bottom sheet
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                          color: Color(int.parse(colors[
                                                  index % colors.length]
                                              .replaceFirst('#',
                                                  '0xff'))), // Color of the container
                                          borderRadius: BorderRadius.circular(
                                              20), // Optional: makes the containers slightly rounded
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 25,
                          width: 100,
                          margin: EdgeInsets.only(right: 10, bottom: 8),
                          padding: EdgeInsets.only(top: 0),
                          decoration: BoxDecoration(
                            color: Color(int.parse(_selectedColor.replaceFirst(
                                '#',
                                '0xff'))), // Use the selected color for container
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: SizedBox(
                            height: 30,
                            width: textFieldWidth * .1,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 8, right: 3),
                        child: Text(
                          "هدف",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: labelColor),
                        ),
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Container(
                              padding: EdgeInsets.only(top: 15),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: SizedBox(
                                width: textFieldWidth * .4,
                                height: 26,
                                child: TextField(
                                  controller: _goalCount,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 20, 20,
                                        20), // Set text color to white
                                    fontSize: fontSize,
                                  ),
                                  decoration: InputDecoration(
                                      hintText: 'تعداد تکرار',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      hintStyle: TextStyle(
                                        color: Color.fromARGB(205, 86, 84, 84),
                                        fontSize:
                                            fontSize, // Adjusted font size
                                      )),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            // width: 34,
                            height: 41,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2))),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    List<String> timeUnits = [
                                      'ساعت',
                                      'دقیقه',
                                      'ثانیه',
                                      'دفعه'
                                    ]; // Values to be shown in the bottom drawer
                                    return Container(
                                      padding: EdgeInsets.all(20),
                                      child: ListView.builder(
                                        itemCount: timeUnits.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedTimeUnit = timeUnits[
                                                    index]; // Update the selected time unit
                                              });
                                              Navigator.pop(
                                                  context); // Close the bottom sheet
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  bottom:
                                                      10), // Gap between items
                                              padding: EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                color: Colors
                                                    .lightBlue, // Container fill color
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10), // Border radius
                                              ),
                                              child: Text(
                                                timeUnits[index],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  _selectedTimeUnit != ""
                                      ? _selectedTimeUnit
                                      : "نوع بازه را انتخاب کنید",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ), // Button text
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                /////////////////////////////////////////////////////////
                Container(
                  margin: EdgeInsets.only(bottom: 35),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            reminderClicked = true;
                          });
                        },
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 6),
                              constraints: BoxConstraints(
                                maxWidth: 400, // Set your desired maximum width
                                // minHeight, maxHeight, minWidth can also be specified
                              ),
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 241, 241, 241),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4)),
                              child: SizedBox(
                                width: textFieldWidth * .8 - 22,
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween, // Spread the containers evenly in the row
                                    children: <Widget>[
                                      // First container: Radio button and label
                                      Container(
                                        child: Row(
                                          children: [
                                            Checkbox(
                                              value: reminderClicked,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  reminderClicked = value ??
                                                      false; // Update based on checkbox's value
                                                });
                                              },
                                            ),
                                            Text(
                                              "یاد آور",
                                              style: TextStyle(
                                                color: labelColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Second container: Displays the selected time
                                      Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 199, 199, 198),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Text(
                                          '${selectedTime.format(context)}',
                                          style: TextStyle(
                                            color: reminderClicked
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ),
                                      ),

                                      // Third container: Button that shows a time picker
                                      Container(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromARGB(
                                                255,
                                                111,
                                                176,
                                                204), // Set the background color to gray
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      4), // No border radius
                                            ),
                                          ),
                                          onPressed: reminderClicked
                                              ? () async {
                                                  final TimeOfDay? newTime =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime: selectedTime,
                                                  );
                                                  if (newTime != null) {
                                                    setState(() {
                                                      selectedTime = newTime;
                                                    });
                                                  }
                                                }
                                              : null,
                                          child: Text('انتخاب زمان'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (reminderClicked) // Conditionally display the days container
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              // Use Expanded to ensure the SingleChildScrollView takes up all available space in the Row
                              child: SingleChildScrollView(
                                scrollDirection: Axis
                                    .horizontal, // Makes the SingleChildScrollView scroll horizontally
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: 8), // Add some margin at the top
                                  child: Wrap(
                                    // Use Wrap for responsiveness
                                    spacing:
                                        8, // Horizontal space between chips
                                    runSpacing:
                                        4, // Vertical space between chips
                                    children: List.generate(
                                      weekDays.length,
                                      (index) => GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            daySelected[index] =
                                                !daySelected[index];
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 7,
                                              right: 7,
                                              top: 4,
                                              bottom: 4),
                                          decoration: BoxDecoration(
                                            color: daySelected[index]
                                                ? const Color.fromARGB(
                                                    255, 160, 231, 162)
                                                : Color.fromARGB(49, 220, 142,
                                                    93), // Change color based on selection
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            weekDays[index],
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // If Divider is meant to be vertical and separating items within the row, it should be placed accordingly.
                            // If it's meant to be a horizontal divider under the row, you might need to adjust its placement outside of this Row widget structure.
                          ],
                        )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 14),
                      child: Text(
                        "انتخاب تاریخ",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: labelColor),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DateSelectionButton(
                            date: dateMap['startDate'],
                            buttonText: 'تاریخ شروع',
                            onDateSelected: (selectedDate) =>
                                _updateDate('startDate', selectedDate),
                            datee: "startDate"),
                        DateSelectionButton(
                            date: dateMap['endDate'],
                            buttonText: 'تاریخ پایان',
                            onDateSelected: (selectedDate) =>
                                _updateDate('endDate', selectedDate),
                            datee: "endDate"),
                      ],
                    ),
                  ],
                  ////////////////

                  ////////////////
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Centers the buttons with space in between
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          // Simply navigate back to the previous page
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              'انصراف',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          saveHabit();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text('ذخیره',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
