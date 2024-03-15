import 'package:flutter/cupertino.dart';
import 'package:weekdays/views/Habits/date_selection_button.dart';

class SetDate extends StatelessWidget {
  final Color labelColor;
  final Map<String, DateTime?> dateMap;
  final Function(String key, DateTime? selectedDate) updateDate;
  const SetDate({
    super.key,
    required this.labelColor,
    required this.dateMap,
    required this.updateDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 4, bottom: 14),
          child: Text(
            "انتخاب تاریخ",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: labelColor),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DateSelectionButton(
                date: dateMap['startDate'],
                buttonText: 'تاریخ شروع',
                onDateSelected: (selectedDate) =>
                    updateDate('startDate', selectedDate),
                datee: "startDate"),
            DateSelectionButton(
                date: dateMap['endDate'],
                buttonText: 'تاریخ پایان',
                onDateSelected: (selectedDate) =>
                    updateDate('endDate', selectedDate),
                datee: "endDate"),
          ],
        ),
      ],
    );
  }
}
