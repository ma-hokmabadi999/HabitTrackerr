import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Reminder extends StatelessWidget {
  final bool reminderClicked;
  final double textFieldWidth;
  final Color labelColor;
  final TimeOfDay selectedTime;
  final List<String> weekDays;
  final List<bool> daySelected;
  final Function(int) setDaySelected;
  final Function(bool) setReminderClick;
  final Function(TimeOfDay) setSelectedTime;
  const Reminder({
    super.key,
    required this.reminderClicked,
    required this.textFieldWidth,
    required this.labelColor,
    required this.selectedTime,
    required this.weekDays,
    required this.daySelected,
    required this.setReminderClick,
    required this.setSelectedTime,
    required this.setDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 35),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setReminderClick(true);
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
                      color: const Color.fromARGB(255, 241, 241, 241),
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
                                    setReminderClick(value ?? false);
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
                                color: const Color.fromARGB(255, 199, 199, 198),
                                borderRadius: BorderRadius.circular(4)),
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
                                backgroundColor: Color.fromARGB(255, 111, 176,
                                    204), // Set the background color to gray
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
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
                                        setSelectedTime(newTime);
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
                      margin:
                          EdgeInsets.only(top: 8), // Add some margin at the top
                      child: Wrap(
                        // Use Wrap for responsiveness
                        spacing: 8, // Horizontal space between chips
                        runSpacing: 4, // Vertical space between chips
                        children: List.generate(
                          weekDays.length,
                          (index) => GestureDetector(
                            onTap: () {
                              setDaySelected(index);
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 7, right: 7, top: 4, bottom: 4),
                              decoration: BoxDecoration(
                                color: daySelected[index]
                                    ? const Color.fromARGB(255, 160, 231, 162)
                                    : Color.fromARGB(49, 220, 142,
                                        93), // Change color based on selection
                                borderRadius: BorderRadius.circular(10),
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
    );
  }
}
