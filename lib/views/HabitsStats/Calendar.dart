import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:isar/isar.dart';
import 'dart:math';
import 'package:shamsi_date/shamsi_date.dart';
import '../../models/showhabit/ShowHabitService.dart';

class CustomCalendar extends StatefulWidget {
  final bool isNone;
  final Isar isar;
  final String name;
  const CustomCalendar({
    Key? key,
    required this.isar,
    required this.name,
    required this.isNone,
  }) : super(key: key);

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  Jalali _focusedDay = Jalali.now();
  late Map<Jalali, double> _fillPercentages;
  double defaultBorderRadios = 10;
  late final ShowHabitService _showHabitService;

  @override
  void initState() {
    super.initState();
    _initializeFillPercentages();
    _showHabitService = ShowHabitService(widget.isar);
  }

  void _initializeFillPercentages() {
    Map<Jalali, double> fillPercentagestemp = {};
    int totalDays = _focusedDay.monthLength;
    for (int i = 1; i <= totalDays; i++) {
      fillPercentagestemp[Jalali(_focusedDay.year, _focusedDay.month, i)] = 0;
    }
    setState(() {
      _fillPercentages = fillPercentagestemp;
    });
  }

  Future<Map<Jalali, double>> getNewPercentages(
      String name, Map<Jalali, double> originPercentages) async {
    print("doingit%%%%");
    Map<Jalali, double> temp = originPercentages;
    List<Jalali> keysList = _fillPercentages.keys.toList();
    double tempPercentage = 0.0;
    for (var i = 0; i < keysList.length; i++) {
      DateTime gregorianDate = convertToGregorianWithMidnight(keysList[i]);
      tempPercentage = await _showHabitService
          .getShowHabitByNameAndDatePercentage(gregorianDate, name);
      temp[keysList[i]] = tempPercentage;
    }
    print(temp.toString());
    print(temp.length);
    return temp;
  }

  DateTime convertToGregorianWithMidnight(Jalali date) {
    // Assuming _focusedDay is your Jalali date

    // Convert Jalali to Gregorian
    Gregorian gregorianDate = date.toGregorian();

    // Create a new DateTime object with the time set to midnight (00:00:00)
    return DateTime(
        gregorianDate.year, gregorianDate.month, gregorianDate.day, 0, 0, 0);
  }

  void _selectYear(BuildContext context) async {
    int selectedYear = await showModalBottomSheet<int>(
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: SizedBox(
                height: 200, // Adjust the height as necessary
                child: ListView.builder(
                  itemCount: 1408 - 1400 + 1, // From year 1400 to 1408
                  itemBuilder: (context, index) {
                    int year = 1400 + index;
                    return ListTile(
                      title: Text('$year'),
                      onTap: () => Navigator.pop(context, year),
                    );
                  },
                ),
              ),
            );
          },
        ) ??
        _focusedDay.year; // Use current year if selection is canceled

    setState(() {
      _focusedDay = Jalali(selectedYear, _focusedDay.month, _focusedDay.day);
      _initializeFillPercentages();
    });
  }

  void _selectMonth(BuildContext context) async {
    List<String> months = [
      'Farvardin',
      'Ordibehesht',
      'Khordad',
      'Tir',
      'Mordad',
      'Shahrivar',
      'Mehr',
      'Aban',
      'Azar',
      'Dey',
      'Bahman',
      'Esfand'
    ];
    int selectedMonth = await showModalBottomSheet<int>(
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: SizedBox(
                height: 300, // Adjust the height as necessary
                child: ListView.builder(
                  itemCount: months.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(months[index]),
                      onTap: () => Navigator.pop(context, index + 1),
                    );
                  },
                ),
              ),
            );
          },
        ) ??
        _focusedDay.month; // Use current month if selection is canceled

    setState(() {
      _focusedDay = Jalali(_focusedDay.year, selectedMonth, _focusedDay.day);
      _initializeFillPercentages();
    });
  }

  Widget _buildDayWidget(Jalali day, double fillPercentage) {
    // Ensure fillPercentage is within bounds
    fillPercentage = fillPercentage.clamp(0.0, 1.0);

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double maxHeight = constraints.maxHeight;
            double fillHeight = maxHeight * fillPercentage;

            return Container(
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                // color: Colors.black,
                borderRadius: BorderRadius.circular(defaultBorderRadios),
              ),
              child: ClipRRect(
                // ClipRRect applied to the entire box
                borderRadius: BorderRadius.circular(defaultBorderRadios),

                child: Container(
                  margin: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    // border: Border.all(color: Colors.black54),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: fillHeight,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: fillPercentage == 0
                                  ? Color.fromARGB(255, 77, 76, 76)
                                  : Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyDayWidget([Jalali? day]) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultBorderRadios),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(defaultBorderRadios),
                child: Container(
                  margin: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: day != null
                        ? Colors.grey[200]
                        : Colors
                            .transparent, // Adjust the background color as needed
                    // border: Border.all(
                    //   color: Colors.grey, // Adjust border color as needed
                    //   width: 1, // Adjust border width as needed
                    // ),
                  ),
                  child: Center(
                    child: day != null
                        ? Text(
                            '${day.day}',
                            style: TextStyle(color: Colors.grey),
                          )
                        : Container(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _gotoPreviousMonth() {
    setState(() {
      // Move to the previous month
      _focusedDay = _focusedDay.addMonths(-1);
      _initializeFillPercentages();
    });
  }

  void _gotoNextMonth() {
    setState(() {
      // Move to the next month
      _focusedDay = _focusedDay.addMonths(1);
      _initializeFillPercentages();
    });
  }

  final List<String> _dayInitials = [
    'ش',
    'ی',
    'د',
    'س',
    'چ',
    'پ',
    'ج'
  ]; // Starting from Saturday
  Widget _ArrowForMonth(VoidCallback onTap, IconData icon) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(defaultBorderRadios),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 15,
        ),
      ),
    );
  }

  Widget _buildDayInitialsRow() {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _dayInitials.map((initial) {
          return Expanded(
            child: Center(
              child: Text(
                initial,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid(Map<Jalali, double> monthList) {
    List<Widget> weekRows = [];
    int totalDays = _focusedDay.monthLength;
    Jalali firstDayOfMonth = Jalali(_focusedDay.year, _focusedDay.month, 1);
    int weekdayOfFirstDay =
        firstDayOfMonth.weekDay; // Adjusted to use the correct method/property
    int dayCounter = 1 - weekdayOfFirstDay + 1;

    for (int week = 0; week < 6; week++) {
      List<Widget> dayWidgets = List.generate(7, (index) {
        if (dayCounter <= 0) {
          // Calculate the day in the previous month
          Jalali lastMonthDay = Jalali(_focusedDay.year, _focusedDay.month, 1)
              .addDays(dayCounter - 1);
          dayCounter++;
          return _buildEmptyDayWidget(lastMonthDay);
        } else if (dayCounter > totalDays) {
          // Calculate the day in the next month
          Jalali nextMonthDay =
              Jalali(_focusedDay.year, _focusedDay.month, totalDays)
                  .addDays(dayCounter - totalDays);
          dayCounter++;
          return _buildEmptyDayWidget(nextMonthDay);
        } else {
          // Current month day
          Jalali currentDay =
              Jalali(_focusedDay.year, _focusedDay.month, dayCounter);
          double fillPercentage = monthList[currentDay] ?? 0.0;
          dayCounter++;
          return _buildDayWidget(currentDay, fillPercentage);
        }
      });
      weekRows.add(Row(children: dayWidgets));
      if (dayCounter > totalDays) break;
    }

    return Container(
      height: 276, // Set a fixed height for the container
      child: Column(children: weekRows),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double maxWidth = min(constraints.maxWidth, 500.0);
          return Center(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors
                    .white, // Background color is necessary for the shadow to be visible
                borderRadius: BorderRadius.circular(8),

                boxShadow: [
                  BoxShadow(
                    color: Colors.grey
                        .withOpacity(0.5), // Shadow color and opacity
                    spreadRadius: 2, // Spread radius
                    blurRadius: 7, // Blur radius
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _ArrowForMonth(
                            () => _gotoNextMonth(), Icons.arrow_back),
                        Flexible(
                          // Make the date selection flexible to use the available space
                          fit: FlexFit.tight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DateSelectButton(
                                text: _focusedDay.month.toString(),
                                onTap: () => _selectMonth(context),
                                isMonth: true,
                                maxWidth: maxWidth,
                              ),
                              DateSelectButton(
                                text: _focusedDay.year.toString(),
                                onTap: () => _selectYear(context),
                                isMonth: false,
                                maxWidth: maxWidth,
                              ),
                            ],
                          ),
                        ),
                        _ArrowForMonth(
                            () => _gotoPreviousMonth(), Icons.arrow_forward),
                      ],
                    ),
                  ),
                  _buildDayInitialsRow(),
                  ShowCalendar(
                    name: widget.name,
                    originPercentages: _fillPercentages,
                    getNewPercentages: getNewPercentages,
                    maxWidth: maxWidth,
                    buildCalendarGrid: _buildCalendarGrid,
                    isNone: widget.isNone,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ShowCalendar extends StatefulWidget {
  final bool isNone;
  final Function(Map<Jalali, double>) buildCalendarGrid;
  final String name;
  final double maxWidth;
  final Map<Jalali, double> originPercentages;
  final Function(String name, Map<Jalali, double> originPercentages)
      getNewPercentages;
  const ShowCalendar({
    super.key,
    required this.name,
    required this.originPercentages,
    required this.getNewPercentages,
    required this.maxWidth,
    required this.buildCalendarGrid,
    required this.isNone,
  });

  @override
  State<ShowCalendar> createState() => _ShowCalendarState();
}

class _ShowCalendarState extends State<ShowCalendar> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<Jalali, double>>(
      future: widget.getNewPercentages(widget.name, widget.originPercentages),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Container(
            width: widget.maxWidth,
            child: widget.buildCalendarGrid(
                !widget.isNone ? snapshot.data! : widget.originPercentages),
          );
        } else {
          return Container(
            width: widget.maxWidth,
            child: widget.buildCalendarGrid(widget.originPercentages),
          );
        }
      },
    );
  }
}

class DateSelectButton extends StatelessWidget {
  final bool isMonth;
  final String text;
  final VoidCallback onTap;
  final double maxWidth;
  const DateSelectButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.isMonth,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isMonth ? maxWidth * .15 : maxWidth * .2,
        margin: EdgeInsets.only(right: 8, left: 8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 4, 158, 160),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.w500,
                  fontSize: maxWidth * .035),
            ),
          ],
        ),
      ),
    );
  }
}
