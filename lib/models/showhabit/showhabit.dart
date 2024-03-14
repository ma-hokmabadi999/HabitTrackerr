import 'package:isar/isar.dart';

part 'showhabit.g.dart';

@Collection()
class ShowHabit {
  Id id = Isar.autoIncrement;

  late String name;
  late DateTime date;
  late int goalCount;
  late int modifiedGoalCount;
  late String color;
}
