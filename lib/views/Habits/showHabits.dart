import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:weekdays/models/habit/gotHabitProvider.dart';
import 'package:weekdays/models/habit/habit.dart';
import 'package:weekdays/models/showhabit/ShowHabitService.dart';
import 'package:weekdays/models/showhabit/showhabit.dart';
import 'package:weekdays/views/Habits/HabitsProgressBar.dart';
import '../../models/habit/HabitService.dart' show HabitService;
import 'package:isar/isar.dart';

class HabitsView extends StatefulWidget {
  final Isar isar;
  final DateTime date;
  final Function(bool) setIsLoaded;
  const HabitsView({
    Key? key,
    required this.isar,
    required this.date,
    required this.setIsLoaded,
  }) : super(key: key);

  @override
  _HabitsViewState createState() => _HabitsViewState();
}

class _HabitsViewState extends State<HabitsView> {
  late final HabitService _habitService;
  late final bool checkDate;
  late final ShowHabitService _showHabitService;
  DateTime tomorrow = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day + 1, 0, 0, 0);

  @override
  void initState() {
    _habitService = HabitService();
    _showHabitService = ShowHabitService(widget.isar);
    checkDate =
        widget.date.isAfter(tomorrow) || widget.date.isAtSameMomentAs(tomorrow);
    _habitService.cacheHabits(widget.isar);
    print("STREAM STARTED");
    super.initState();
  }

  Future<List<ShowHabit>> filterHabitsByDate(
      BuildContext context, List<Habit> habits) async {
<<<<<<< HEAD
    // _habitService.cacheHabits(widget.isar);
=======
>>>>>>> 7283a164704c560efb9d76a3bb0baafd0d4cafe8
    DateTime defaultEndDate = DateTime(1970, 1, 1);
    final filtered = habits.where((habit) {
      final bool isStartDateValid =
          habit.startDate.isBefore(widget.date.add(Duration(days: 1)));
      final bool isEndDateValid =
          habit.endDate.isAfter(widget.date.subtract(Duration(days: 1))) ||
              habit.endDate.isAtSameMomentAs(defaultEndDate);
      return isStartDateValid && isEndDateValid;
    }).toList();

    return _showHabitService.getListProgressBarShowHabit(filtered, widget.date);
  }

  Future<void> updateShowHabit(
      ShowHabit showHabit, int modifiedGoalCount) async {
    await _showHabitService.updateShowHabitHabitByModifiedGoalCount(
        showHabit.id, modifiedGoalCount);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _habitService.allHabits,
      builder: (context, snapshot) {
        return FutureBuilder<List<ShowHabit>>(
          future: snapshot.hasData
              ? filterHabitsByDate(context, snapshot.data!)
              : Future.value([]),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Provider.of<CounterModel>(context, listen: false)
                    .getStatus(true);
              });

              return HabitsProgressBar(
                checkDate: checkDate,
                showHabits: snapshot.data!,
                updateShowHabit: updateShowHabit,
                date: widget.date,
                setIsLoaded: widget.setIsLoaded,
              );
            } else {
              return Container(
                margin: EdgeInsets.all(10),
                child: Text("data"),
              );
            }
          },
        );
      },
    );
  }
}
