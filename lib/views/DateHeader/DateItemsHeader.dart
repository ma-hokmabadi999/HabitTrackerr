// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_import, use_super_parameters, file_names, unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'WeekItem.dart';

class DateItemsHeader extends StatelessWidget {
  final List<List> datesList;
  final int? selectedIndex;
  final Function(int) onDateSelected;
  final Function(DateTime) setDateHabit;

  const DateItemsHeader({
    super.key,
    required this.datesList,
    this.selectedIndex,
    required this.onDateSelected,
    required this.setDateHabit,
  });

  onWeekItemTap(int index, String dateString) {
    List<String> parts = dateString.split('/');
    int month = int.parse(parts[0]);
    int day = int.parse(parts[1]);
    int year = int.parse(parts[2]);

// Creating a new DateTime object with time set to midnight.
    DateTime dateWithZeroTime = DateTime(year, month, day, 0, 0, 0);
    onDateSelected(index);
    setDateHabit(dateWithZeroTime);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> dateWidgets = List.generate(datesList.length, (index) {
      bool isSelected;

      isSelected = selectedIndex == index;

      return WeekdayItem(
        dayName: datesList[index][0],
        date: datesList[index][1],
        isSelected: isSelected,
        onTap: () => onWeekItemTap(index, datesList[index][1]),
        setDateHabit: setDateHabit,
      );
    });

    return Container(
      alignment: Alignment.center,
      // margin: const EdgeInsets.all(3),
      // height: preferredSize.height,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(202, 19, 19, 1),
        // borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center the items horizontally
        children: dateWidgets,
      ),
    );
  }
}
