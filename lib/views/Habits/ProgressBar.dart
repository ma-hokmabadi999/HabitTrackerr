// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:persian_tools/persian_tools.dart';

import 'package:weekdays/models/showhabit/showhabit.dart';
import 'package:weekdays/utilities/dialogs/sameDate_dialog.dart';

class ProgressBar extends StatefulWidget {
  final Function(ShowHabit, int) updateShowHabit;
  final ShowHabit showHabit;
  final bool checkDate;
  final DateTime date;

  const ProgressBar(
      {Key? key,
      required this.date,
      required this.showHabit,
      required this.updateShowHabit,
      required this.checkDate})
      : super(key: key);

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  late double _fillPercentage;
  late int _tempModifiedGoalCount;
  Timer? _timer;
  GlobalKey containerKey = GlobalKey();

  void _startPeriodicTask() {
    // This function is scheduled to run every 0.2 seconds
    const period = Duration(milliseconds: 200);
    _timer = Timer.periodic(period, (timer) async {
      // Place your repeating task or function call here
      await widget.updateShowHabit(widget.showHabit, _tempModifiedGoalCount);
    });
  }

  @override
  void initState() {
    super.initState();

    _tempModifiedGoalCount = widget.showHabit.modifiedGoalCount;
    _fillPercentage =
        (_tempModifiedGoalCount / widget.showHabit.goalCount).toDouble();
    _startPeriodicTask();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to prevent memory leaks
    _timer?.cancel();
    widget.updateShowHabit(widget.showHabit, _tempModifiedGoalCount);
    super.dispose();
  }

  void _updateFillPercentage(double percentage, BuildContext context) {
    if (percentage <= 0.04) {
      percentage = 0.0;
    } else if (percentage >= 0.92) {
      percentage = 1;
    }

    DateTime tomorrow = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day + 1, 0, 0, 0);

    bool checkDate =
        widget.date.isAfter(tomorrow) || widget.date.isAtSameMomentAs(tomorrow);

    if (checkDate == false) {
      setState(() {
        _fillPercentage = percentage;
        _tempModifiedGoalCount =
            (widget.showHabit.goalCount * percentage).toInt();
      });
    } else {
      showSameDateDialog(context);
    }
  }

  Color lightenColor(String hexColor, [double amount = 0.65]) {
    final color = Color(int.parse(hexColor.replaceFirst('#', '0xff')));
    final r = (color.red + (255 - color.red) * amount).clamp(0, 255).toInt();
    final g =
        (color.green + (255 - color.green) * amount).clamp(0, 255).toInt();
    final b = (color.blue + (255 - color.blue) * amount).clamp(0, 255).toInt();
    return Color.fromRGBO(r, g, b, 1);
  }

  Color ensureContrastWithWhite(Color color) {
    // A placeholder function that checks if the color is dark enough for white text
    // and adjusts it if not. This is a simplified example.
    final luminance = color.computeLuminance();
    // Threshold might need adjustment based on your needs or specific contrast ratio requirements
    const threshold = 0.5;

    if (luminance > threshold) {
      // If the color is too light for white text, make it darker
      // This is a simple method and might not be suitable for all colors
      return Color.fromARGB(color.alpha, (color.red * 0.9).toInt(),
          (color.green * 0.9).toInt(), (color.blue * 0.9).toInt());
    } else {
      // If the color is already dark enough, return it unchanged
      return color;
    }
  }

  @override
  Widget build(BuildContext context) {
    final containerWidth = MediaQuery.of(context).size.width - 15;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final RenderBox box =
            containerKey.currentContext!.findRenderObject() as RenderBox;
        final double dx = details.localPosition.dx;
        final double percentageFill = isRtl
            ? 1.0 - (dx / containerWidth).clamp(0.0, 1.0)
            : (dx / containerWidth).clamp(0.0, 1.0);

        _updateFillPercentage(percentageFill, context);
      },
      onTapUp: (details) {
        final RenderBox box =
            containerKey.currentContext!.findRenderObject() as RenderBox;
        final Offset localPosition = box.globalToLocal(details.globalPosition);
        final double dx =
            isRtl ? containerWidth - localPosition.dx : localPosition.dx;
        final double percentageFill = (dx / containerWidth).clamp(0.0, 1.0);

        _updateFillPercentage(percentageFill, context);
      },
      child: Container(
        key: containerKey,
        height: 60,
        width: containerWidth + 20,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          color: ensureContrastWithWhite(lightenColor(widget.showHabit.color)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Stack(
          children: [
            Container(
              width: containerWidth * _fillPercentage,
              height: 60,
              decoration: BoxDecoration(
                color: Color(int.parse(
                    widget.showHabit.color.replaceFirst('#', '0xff'))),
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    textonbar(
                        text: '${widget.showHabit.name} - مقدار : ',
                        right: true),
                    textonbar(
                      text: '${widget.showHabit.goalCount}',
                    ),
                    textonbar(
                      text: '/ $_tempModifiedGoalCount ',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class textonbar extends StatelessWidget {
  final String text;
  final bool right;
  const textonbar({super.key, required this.text, this.right = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: right ? 20 : 1, left: 1),
      child: Text(
        convertEnToFa(text),
        style: TextStyle(
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
}
