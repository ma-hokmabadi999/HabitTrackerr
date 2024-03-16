import 'package:weekdays/models/habit/habit.dart';

import 'showhabit.dart';
import 'package:isar/isar.dart';
import '../habit_exceptation.dart';
import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:intl/intl.dart';

class ShowHabitService {
  final Isar isar;

  ShowHabitService(this.isar);

  Stream<List<ShowHabit>> watchAllShowHabits() {
    // Initiate a query that selects all documents
    return isar.showHabits.where().watch(fireImmediately: true);
  }

  Future<void> addShowHabit(ShowHabit showHabit) async {
    if (showHabit.name != "") {
      await isar.writeTxn(() async {
        await isar.showHabits.put(showHabit);
      });
    } else {
      throw EmptyHabitName();
    }
  }

  Future<ShowHabit?> getShowHabitById(int habitId) async {
    return isar.showHabits.get(habitId);
  }

  Future<void> updateShowHabit(int habitId, ShowHabit showHabit) async {
    final existingShowHabit = await getShowHabitById(habitId);

    if (existingShowHabit != null) {
      existingShowHabit.name = showHabit.name;
      existingShowHabit.date = showHabit.date;
      existingShowHabit.goalCount = showHabit.goalCount;
      existingShowHabit.modifiedGoalCount = showHabit.modifiedGoalCount;
      existingShowHabit.color = showHabit.color;
      await isar.writeTxn(() async {
        await isar.showHabits.put(existingShowHabit);
      });
    }
  }

  Future<void> updateShowHabitHabitByModifiedGoalCount(
      int showHabitId, int modifiedGoalCount) async {
    // print("opopopopoo");
    final existingShowHabit = await getShowHabitById(showHabitId);
    if (existingShowHabit != null) {
      existingShowHabit.modifiedGoalCount = modifiedGoalCount;
      await isar.writeTxn(() async {
        await isar.showHabits.put(existingShowHabit);
      });
    }
  }

  Future<List<ShowHabit>> getListProgressBarShowHabit(
      List<Habit> habits, DateTime date) async {
    List<ShowHabit> listOfProgressBars = [];
    for (var habit in habits) {
      ShowHabit showHabit = await getOrCreateProgressBarShowHabit(habit, date);
      listOfProgressBars.add(showHabit);
    }
    return listOfProgressBars;
  }

  Future<double> getShowHabitByNameAndDatePercentage(
      DateTime dateItem, String name) async {
    var showHabit = await getShowHabitByNameAndDate(name, dateItem);
    if (showHabit != null) {
      return showHabit.modifiedGoalCount / showHabit.goalCount;
    } else {
      return 0.0;
    }
  }

  Future<ShowHabit> getOrCreateProgressBarShowHabit(
      Habit habit, DateTime date) async {
    ShowHabit? foundShowHabit =
        await getShowHabitByNameAndDate(habit.name, date);
    if (foundShowHabit != null) {
      // If a habit is found, return it
      return foundShowHabit;
    } else {
      // If no habit is found, create a new one
      ShowHabit newShowHabit = ShowHabit()
        ..name = habit.name
        ..date = date
        ..goalCount = habit.goalCount // Example default value
        ..modifiedGoalCount = 0 // Example default value
        ..color = habit.color;

      await addShowHabit(
          newShowHabit); // Assuming this method handles the Isar transaction

      // Assuming the 'addShowHabit' method doesn't return the newly created habit, fetch it again.
      // This is to ensure the returned object has its auto-incremented ID set.
      ShowHabit? createdShowHabit =
          await getShowHabitByNameAndDate(habit.name, date);

      if (createdShowHabit != null) {
        return createdShowHabit;
      } else {
        // This should not happen, but it's here to satisfy null-safety requirements.
        throw Exception("Failed to create the habit.");
      }
    }
  }

  Future<ShowHabit?> getShowHabitByNameAndDate(
      String name, DateTime date) async {
    final query = await isar.showHabits
        .filter()
        .nameEqualTo(name)
        .and()
        .dateEqualTo(date)
        .findFirst(); // Use findFirst() to get the first matching document

    return query;
  }

  Future<void> deleteShowHabit(int showHabitId) async {
    await isar.writeTxn(() async {
      bool deleted = await isar.showHabits.delete(showHabitId);
      if (!deleted) {
        // If no habit was deleted (e.g., no habit found with the given ID), you might want to handle this case.
        // For now, let's just throw an exception.
        throw Exception("Habit not found with ID: $showHabitId");
      }
    });
  }

  // Add more CRUD operations as needed
}
