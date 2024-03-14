import 'dart:async';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:weekdays/models/habit/habit.dart';
// import '../models/habit.dart';
// import '../exceptions/habit_exceptions.dart';
import './../habit_exceptation.dart';

class HabitService with ChangeNotifier {
  // final Isar isar;
  List<Habit> _habits = [];

  static final HabitService _shared = HabitService._sharedInstance();
  HabitService._sharedInstance() {
    _habitsStreamController = StreamController<List<Habit>>.broadcast(
      onListen: () {
        _habitsStreamController.sink.add(_habits);
      },
    );
  }
  factory HabitService() => _shared;

  late final StreamController<List<Habit>> _habitsStreamController;

  Stream<List<Habit>> get allHabits => _habitsStreamController.stream;

  Future<void> cacheHabits(Isar isar) async {
    final allHabits = await isar.habits.where().findAll();
    print("balerererer");
    _habits = allHabits.toList();
    _habitsStreamController.add(_habits);
  }

  Future<void> addHabit(Habit habit, Isar isar) async {
    if (habit.name != "") {
      await isar.writeTxn(() async {
        await isar.habits.put(habit);
        await cacheHabits(isar);
      });
    } else {
      throw EmptyHabitName();
    }
  }

  Future<void> updateHabit(int habitId, Habit habit, Isar isar) async {
    final existingHabit = await isar.habits.get(habitId);
    if (existingHabit != null) {
      await isar.writeTxn(() async {
        await isar.habits.put(habit);
        await cacheHabits(isar);
      });
    } else {
      throw EmptyHabitName();
    }
  }

  Future<void> deleteHabit(int habitId, Isar isar) async {
    final habit = await isar.habits.get(habitId);
    if (habit != null) {
      await isar.writeTxn(() async {
        bool deleted = await isar.habits.delete(habitId);
        if (deleted) {
          _habits.removeWhere((element) => element.id == habitId);
          _habitsStreamController.add(_habits);
        } else {
          throw EmptyHabitName();
        }
      });
    } else {
      throw EmptyHabitName();
    }
  }

  // Add other necessary methods and handle exceptions as required
}
