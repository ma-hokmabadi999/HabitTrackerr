// import 'package:flutter/material.dart';
// import 'package:isar/isar.dart';
// import 'package:weekdays/models/habit/habit.dart';
// import 'package:weekdays/models/showhabit/ShowHabitService.dart';
// import 'package:weekdays/models/showhabit/showhabit.dart';
// import 'package:weekdays/views/Habits/HabitsProgressBar.dart';

// class HabitListView extends StatefulWidget {
//   final Isar isar;
//   final List<Habit> habits;
//   final DateTime date;
//   final Function(Habit) onDeleteHabit;
//   final Function(Habit) onTap;
//   final Function(bool) setIsLoaded;

//   const HabitListView({
//     Key? key,
//     required this.habits,
//     required this.date,
//     required this.onDeleteHabit,
//     required this.onTap,
//     required this.isar,
//     required this.setIsLoaded,
//   }) : super(key: key);

//   @override
//   _HabitListViewState createState() => _HabitListViewState();
// }

// class _HabitListViewState extends State<HabitListView> {
//   late final ShowHabitService _showHabitService;
//   late final bool checkDate;
//   DateTime tomorrow = DateTime(DateTime.now().year, DateTime.now().month,
//       DateTime.now().day + 1, 0, 0, 0);

//   @override
//   void initState() {
//     super.initState();
//     _showHabitService = ShowHabitService(widget.isar);
//     checkDate =
//         widget.date.isAfter(tomorrow) || widget.date.isAtSameMomentAs(tomorrow);
//   }

//   Future<List<ShowHabit>> filterHabitsByDate(BuildContext context) async {
//     DateTime defaultEndDate = DateTime(1970, 1, 1);
//     final filtered = widget.habits.where((habit) {
//       final bool isStartDateValid =
//           habit.startDate.isBefore(widget.date.add(Duration(days: 1)));
//       final bool isEndDateValid =
//           habit.endDate.isAfter(widget.date.subtract(Duration(days: 1))) ||
//               habit.endDate.isAtSameMomentAs(defaultEndDate);
//       return isStartDateValid && isEndDateValid;
//     }).toList();

//     return _showHabitService.getListProgressBarShowHabit(filtered, widget.date);
//   }

//   Future<void> updateShowHabit(
//       ShowHabit showHabit, int modifiedGoalCount) async {
//     await _showHabitService.updateShowHabitHabitByModifiedGoalCount(
//         showHabit.id, modifiedGoalCount);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<ShowHabit>>(
//       future: filterHabitsByDate(context),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // Return an empty container or a loading indicator as per your need
//           return SizedBox
//               .shrink(); // or Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             widget.setIsLoaded(true);
//           });
//           return HabitsProgressBar(
//             checkDate: checkDate,
//             showHabits: snapshot.data!,
//             updateShowHabit: updateShowHabit,
//             setIsLoaded: widget.setIsLoaded,
//             date: widget.date,
//           );
//         } else {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             widget.setIsLoaded(false);
//           });
//           // If you don't want to show anything when there are no habits, return SizedBox.shrink()
//           return SizedBox.shrink(); // or a message indicating no habits found.
//         }
//       },
//     );
//   }
// }














// class HabitListView extends StatefulWidget {
//   final Isar isar;
//   final List<Habit> habits;
//   final DateTime date;
//   final Function(Habit) onDeleteHabit;
//   final Function(Habit) onTap;
//   final Function(bool) setIsLoaded;

//   const HabitListView({
//     Key? key,
//     required this.habits,
//     required this.date,
//     required this.onDeleteHabit,
//     required this.onTap,
//     required this.isar,
//     required this.setIsLoaded,
//   }) :