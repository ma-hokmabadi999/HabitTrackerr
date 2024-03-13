import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shamsi_date/shamsi_date.dart' as shamsi;
import 'package:persian_tools/persian_tools.dart';

class DateSelectionButton extends StatelessWidget {
  final DateTime? date;
  final String buttonText;
  final String datee;
  final Function(DateTime? selectedDate) onDateSelected;

  const DateSelectionButton({
    Key? key,
    required this.date,
    required this.buttonText,
    required this.onDateSelected,
    required this.datee,
  }) : super(key: key);

  Future<void> _selectDate(BuildContext context, String datee) async {
    shamsi.Jalali tempDatee = shamsi.Jalali.fromDateTime(date!);
    Jalali tempDate = Jalali(tempDatee.year, tempDatee.month, tempDatee.day);
    final Jalali initialJalaliDate =
        date != null || date == DateFormat("MM/dd/yyyy").parse("01/01/1970")
            ? Jalali.fromDateTime(date!).isBefore(Jalali(1380, 1, 1))
                ? Jalali.now()
                : tempDate
            : Jalali.now();

    Jalali? pickedDate = await showPersianDatePicker(
      context: context,
      initialDate: Jalali(initialJalaliDate.year, initialJalaliDate.month,
          initialJalaliDate.day),
      firstDate: Jalali(1348, 1, 1),
      lastDate: Jalali(1504, 12, 29),
    );
    if (pickedDate != null) {
      // Convert the Jalali date to DateTime if needed or use it directly
      DateTime gregorianDate = pickedDate.toDateTime();
      onDateSelected(
          gregorianDate); // or use pickedDate directly if your app uses Jalali dates extensively
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _selectDate(context, datee),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 193, 192, 192),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            date != DateFormat("MM/dd/yyyy").parse("01/01/1970")
                ? convertEnToFa(
                    '${shamsi.Jalali.fromDateTime(date!).year}/${shamsi.Jalali.fromDateTime(date!).month}/${shamsi.Jalali.fromDateTime(date!).day}')
                : buttonText,
            style: TextStyle(
                color: Color.fromARGB(255, 28, 28, 28),
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
