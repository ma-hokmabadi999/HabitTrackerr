import 'package:isar/isar.dart';

part 'habit.g.dart';

@Collection()
class Habit {
  Id id = Isar.autoIncrement;

  late String name;
  late String selectedDays;
  late String color;
  late int goalCount;
  late String timeUnit;
  late DateTime startDate;
  late DateTime endDate;
  late int reminderHour;
  late int reminderMinute;
  late bool isReminderClicked;
}
