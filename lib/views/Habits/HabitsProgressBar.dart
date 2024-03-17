import 'package:flutter/material.dart';
import 'package:weekdays/models/showhabit/showhabit.dart';
import 'package:weekdays/views/Habits/ProgressBar.dart';

class HabitsProgressBar extends StatefulWidget {
  final Function(int, int) updateShowHabit;
  final List<ShowHabit> showHabits;
  final bool checkDate;
  final Function(bool) setIsLoaded;
  final DateTime date;

  const HabitsProgressBar({
    Key? key,
    required this.checkDate,
    required this.date,
    required this.showHabits,
    required this.updateShowHabit,
    required this.setIsLoaded,
  }) : super(key: key);

  @override
  State<HabitsProgressBar> createState() => _HabitsProgressBarState();
}

class _HabitsProgressBarState extends State<HabitsProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: widget.showHabits.length,
        itemBuilder: (context, index) {
          final showHabit = widget.showHabits[index];
          return ProgressBar(
            showHabit: showHabit,
            updateShowHabit: widget.updateShowHabit,
            checkDate: widget.checkDate,
            date: widget.date,
          );
        },
      ),
    );
  }
}

// Widget for animating each item
class AnimatedItem extends StatefulWidget {
  final Widget child;

  const AnimatedItem({Key? key, required this.child}) : super(key: key);

  @override
  _AnimatedItemState createState() => _AnimatedItemState();
}

class _AnimatedItemState extends State<AnimatedItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 1900), // Adjust the speed of the animation
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
