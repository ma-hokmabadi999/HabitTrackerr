// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:weekdays/models/habit/HabitService.dart';
import 'package:weekdays/models/habit/habit.dart';
import 'package:weekdays/views/HabitsStats/Calendar.dart';

class HabitsStats extends StatefulWidget {
  final Isar isar;
  const HabitsStats({super.key, required this.isar});

  @override
  State<HabitsStats> createState() => _HabitsStatsState();
}

class _HabitsStatsState extends State<HabitsStats> {
  int _selectedIndex = 0;
  late final HabitService _habitService;
  @override
  void initState() {
    _habitService = HabitService();
    _habitService.cacheHabits(widget.isar);

    super.initState();
  }

  bool _isNone = false;

  Widget rowHabitSelection(List<Habit> habits) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 2,
            ),
          ),
        ),
        child: Row(
          children: habits.asMap().entries.map((entry) {
            int index = entry.key;
            Habit habit = entry.value;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                  _isNone =
                      false; // Update _isNone as necessary for your use case
                });
              },
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: _selectedIndex == index
                      ? Colors.blue
                      : Color.fromARGB(
                          255, 17, 200, 228), // Highlight selected habit
                ),
                child: Text(
                  habit.name,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget analizeHabit() {
    return StreamBuilder<List<Habit>>(
      stream: _habitService.allHabits,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                rowHabitSelection(snapshot.data),
                CustomCalendar(
                  isar: widget.isar,
                  name: snapshot.data[_selectedIndex].name,
                  isNone: _isNone,
                ),
              ],
            ),
          );
        } else {
          return Text("No data available");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("آنالیز روتین ها"),
      ),
      body: SafeArea(
        child: analizeHabit(),
      ),
    );
  }
}
