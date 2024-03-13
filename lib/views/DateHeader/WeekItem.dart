import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persian_tools/persian_tools.dart';
import 'package:shamsi_date/shamsi_date.dart';

class WeekdayItem extends StatefulWidget {
  final String dayName;
  final String date;
  final bool isSelected;
  final VoidCallback onTap;
  final Function(DateTime) setDateHabit;

  const WeekdayItem({
    Key? key,
    required this.dayName,
    required this.date,
    this.isSelected = false,
    required this.onTap,
    required this.setDateHabit,
  }) : super(key: key);

  @override
  State<WeekdayItem> createState() => _WeekdayItemState();
}

class _WeekdayItemState extends State<WeekdayItem> {
  onWeekItemTap(String dateString) {
    List<String> parts = dateString.split('/');
    int month = int.parse(parts[0]);
    int day = int.parse(parts[1]);
    int year = int.parse(parts[2]);

// Creating a new DateTime object with time set to midnight.
    DateTime dateWithZeroTime = DateTime(year, month, day, 0, 0, 0);
    widget.setDateHabit(dateWithZeroTime);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // if (widget.isSelected) {
  //   //   onWeekItemTap(widget.date);
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: 45,
        height: 70,
        padding: EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? Color.fromARGB(255, 157, 255, 211)
              : Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(60),
          border: Border.all(
              color: widget.isSelected ? Colors.red : Colors.pink,
              width: widget.isSelected ? 2.3 : 1.5),
          boxShadow: [
            widget.isSelected
                ? BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 6),
                  )
                : BoxShadow(),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.dayName.substring(0, 1),
              style: TextStyle(
                color: Color.fromARGB(255, 39, 81, 0),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            // const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  convertEnToFa(Jalali.fromDateTime(
                          DateFormat("MM/dd/yyyy").parse(widget.date))
                      .day
                      .toString()),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 39, 81, 0),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
