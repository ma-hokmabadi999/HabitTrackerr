import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HabitName extends StatelessWidget {
  final TextEditingController habitName;
  final double textFieldWidth;
  final double fontSize;
  final Color labelColor;

  const HabitName({
    super.key,
    required this.fontSize,
    required this.habitName,
    required this.textFieldWidth,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8, right: 3),
            child: Text(
              "نام روتین",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: labelColor),
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
                    controller: habitName,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: TextStyle(
                      color: const Color.fromARGB(
                          255, 20, 20, 20), // Set text color to white
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
    );
  }
}
