import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetGoalTimeUnit extends StatelessWidget {
  final Color labelColor;
  final double textFieldWidth;
  final TextEditingController goalCount;
  final double fontSize;
  final String selectedTimeUnit;
  final Function(String) setTimeUnit;

  const SetGoalTimeUnit({
    super.key,
    required this.labelColor,
    required this.textFieldWidth,
    required this.goalCount,
    required this.fontSize,
    required this.selectedTimeUnit,
    required this.setTimeUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4, bottom: 8, right: 3),
            child: Text(
              "هدف",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: labelColor),
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
                      controller: goalCount,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: TextStyle(
                        color: const Color.fromARGB(
                            255, 20, 20, 20), // Set text color to white
                        fontSize: fontSize,
                      ),
                      decoration: InputDecoration(
                          hintText: 'تعداد تکرار',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(
                            color: Color.fromARGB(205, 86, 84, 84),
                            fontSize: fontSize, // Adjusted font size
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
                                  setTimeUnit(timeUnits[index]);
                                  Navigator.pop(
                                      context); // Close the bottom sheet
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      bottom: 10), // Gap between items
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .lightBlue, // Container fill color
                                    borderRadius: BorderRadius.circular(
                                        10), // Border radius
                                  ),
                                  child: Text(
                                    timeUnits[index],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
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
                      selectedTimeUnit != ""
                          ? selectedTimeUnit
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
    );
  }
}
