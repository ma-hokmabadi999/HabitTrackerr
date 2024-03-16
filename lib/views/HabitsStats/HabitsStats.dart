// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:weekdays/views/HabitsStats/Calendar.dart';

class HabitsStats extends StatefulWidget {
  const HabitsStats({super.key});

  @override
  State<HabitsStats> createState() => _HabitsStatsState();
}

class _HabitsStatsState extends State<HabitsStats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("آنالیز روتین ها"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CustomCalendar(),
          ],
        ),
      ),
    );
  }
}
