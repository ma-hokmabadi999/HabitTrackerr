// ignore_for_file: unused_local_variable, unused_field

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'DateItemsHeader.dart';
import 'package:visibility_detector/visibility_detector.dart';

class weekSlider extends StatefulWidget {
  final Isar isar;
  final int? selectedIndex;
  final Function(int) onDateSelected;
  final Function(DateTime) onFirstDay;
  final Function(DateTime, int) getFirstDayOfWeek;
  final Function(DateTime) getWeekDays;
  final Function(DateTime) setDateHabit;

  final DateTime forFirstDay;
  const weekSlider({
    Key? key,
    required this.selectedIndex,
    required this.onDateSelected,
    required this.onFirstDay,
    required this.forFirstDay,
    required this.isar,
    required this.getFirstDayOfWeek,
    required this.getWeekDays,
    required this.setDateHabit,
  }) : super(key: key);
  @override
  _weekSliderState createState() => _weekSliderState();
}

class _weekSliderState extends State<weekSlider> {
  final PageController _pageController =
      PageController(initialPage: 1000); // Simulate infinite pages
  DateTime _currentWeekStartingDate = DateTime.now();
  int _firstDayOfWeek = DateTime.saturday; // Dynamically changeable

  @override
  void initState() {
    super.initState();
    _currentWeekStartingDate =
        widget.getFirstDayOfWeek(DateTime.now(), _firstDayOfWeek);
  }

  void _toggleStartDayOfWeek() {
    setState(() {
      _firstDayOfWeek = _firstDayOfWeek == DateTime.monday
          ? DateTime.saturday
          : DateTime.monday;
      _currentWeekStartingDate =
          widget.getFirstDayOfWeek(DateTime.now(), _firstDayOfWeek);
      _pageController
          .jumpToPage(1000); // Reset to "initial" page to reflect the change
    });
  }

  onWeekItemTap(String dateString) {
    List<String> parts = dateString.split('/');
    int month = int.parse(parts[0]);
    int day = int.parse(parts[1]);
    int year = int.parse(parts[2]);

// Creating a new DateTime object with time set to midnight.
    DateTime dateWithZeroTime = DateTime(year, month, day, 0, 0, 0);
    widget.setDateHabit(dateWithZeroTime);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        int difference = index - 1000;
        print(difference);
        setState(() {
          _currentWeekStartingDate = widget
              .getFirstDayOfWeek(DateTime.now(), _firstDayOfWeek)
              .add(Duration(days: 7 * difference));
        });
      },
      itemBuilder: (context, index) {
        DateTime weekStartDate = widget
            .getFirstDayOfWeek(widget.forFirstDay, _firstDayOfWeek)
            .add(Duration(days: 7 * (index - 1000)));
        List<List> weekDays = widget.getWeekDays(weekStartDate);
        DateTime parsedDate =
            DateFormat("MM/dd/yyyy").parse(weekDays[widget.selectedIndex!][1]);
        DateTime dateWithTimeZero =
            DateTime(parsedDate.year, parsedDate.month, parsedDate.day);

        return VisibilityDetector(
          key: Key('week-slider-$index'), // Ensure the key is unique
          onVisibilityChanged: (VisibilityInfo info) {
            if (info.visibleFraction > .95) {
              // This DateItemsHeader is now "focused" or active
              // You can do something with this information
              onWeekItemTap(weekDays[widget.selectedIndex!][1]);
            }
          },
          child: DateItemsHeader(
            datesList: weekDays,
            selectedIndex: widget.selectedIndex,
            onDateSelected: widget.onDateSelected,
            setDateHabit: widget.setDateHabit,
          ),
        );
      },
    );
  }
}
