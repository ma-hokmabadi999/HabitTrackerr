// ignore_for_file: unused_local_variable
// test

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:persian_tools/persian_tools.dart';

import 'package:weekdays/models/showhabit/showhabit.dart';
import 'package:weekdays/utilities/dialogs/sameDate_dialog.dart';
import 'package:weekdays/views/Habits/AnimateContainer.dart';

class ProgressBar extends StatefulWidget {
  final Function(int, int) updateShowHabit;
  final ShowHabit showHabit;
  final bool checkDate;
  final DateTime date;

  const ProgressBar({
    Key? key,
    required this.date,
    required this.showHabit,
    required this.updateShowHabit,
    required this.checkDate,
  }) : super(key: key);

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  bool showedSameDateDialog = false;
  late double _fillPercentage;
  late int _tempModifiedGoalCount;
  Timer? _timer;
  GlobalKey containerKey = GlobalKey();
  bool _haveAnimation = false;

  void _startPeriodicTask() {
    const period = Duration(milliseconds: 100);
    _timer = Timer.periodic(period, (timer) async {
      await widget.updateShowHabit(widget.showHabit.id, _tempModifiedGoalCount);
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
    _timer?.cancel();
    widget.updateShowHabit(widget.showHabit.id, _tempModifiedGoalCount);
    super.dispose();
  }

  Future _updateFillPercentage(double percentage, BuildContext context) async {
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
            widget.showHabit.goalCount == 1 && _fillPercentage > .49
                ? 1
                : (widget.showHabit.goalCount * _fillPercentage).toInt();
        if (percentage == 0) {
          _tempModifiedGoalCount = 0;
        }

        // (widget.showHabit.goalCount * percentage).toInt();
        // _fillPercentage = _tempModifiedGoalCount < 1 ? 0.0 : _fillPercentage;
      });
      if (showedSameDateDialog) {
        setState(() {
          showedSameDateDialog = false;
        });
      }
    } else if (!showedSameDateDialog) {
      setState(() {
        showedSameDateDialog = true;
      });
      final temp = await showSameDateDialog(context);
      setState(() {
        showedSameDateDialog = temp;
      });
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
    final luminance = color.computeLuminance();
    const threshold = 0.5;

    if (luminance > threshold) {
      return Color.fromARGB(color.alpha, (color.red * 0.9).toInt(),
          (color.green * 0.9).toInt(), (color.blue * 0.9).toInt());
    } else {
      return color;
    }
  }

  void setHaveAnimation(bool have) {
    setState(() {
      _haveAnimation = have;
    });
  }

  @override
  Widget build(BuildContext context) {
    final containerWidth = MediaQuery.of(context).size.width;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return GestureDetector(
      onHorizontalDragUpdate: (details) async {
        final RenderBox box =
            containerKey.currentContext!.findRenderObject() as RenderBox;
        final double dx = details.localPosition.dx;
        final double percentageFill = isRtl
            ? 1.0 - (dx / containerWidth).clamp(0.0, 1.0)
            : (dx / containerWidth).clamp(0.0, 1.0);

        setHaveAnimation(false);

        await _updateFillPercentage(percentageFill, context);
        if (_fillPercentage == 1) {
          setHaveAnimation(true);
        }
      },
      onHorizontalDragEnd: (details) async {
        if (_tempModifiedGoalCount < 1) {
          await _updateFillPercentage(0.0, context);

          // }
        } else if (_tempModifiedGoalCount == widget.showHabit.goalCount) {
          await _updateFillPercentage(1, context);
          setHaveAnimation(true);
        }
      },
      // onTapUp: (details) {
      //   // final RenderBox box =
      //   //     containerKey.currentContext!.findRenderObject() as RenderBox;
      //   // final double dx = details.localPosition.dx;
      //   // final double percentageFill = isRtl
      //   //     ? 1.0 - (dx / containerWidth).clamp(0.0, 1.0)
      //   //     : (dx / containerWidth).clamp(0.0, 1.0);

      //   // setHaveAnimation(false);

      //   // _updateFillPercentage(percentageFill, context);
      //   if (_fillPercentage == 1) {
      //     setHaveAnimation(true);
      //   }
      //   if (_tempModifiedGoalCount < 1) {
      //     _updateFillPercentage(0.0, context);

      //     // }
      //   } else if (_tempModifiedGoalCount == widget.showHabit.goalCount) {
      //     _updateFillPercentage(1, context);
      //     setHaveAnimation(true);
      //   }
      // },
      // onTapCancel: () {
      //   if (_tempModifiedGoalCount < 1) {
      //     _updateFillPercentage(0.0, context);

      //     // }
      //   } else if (_tempModifiedGoalCount == widget.showHabit.goalCount) {
      //     _updateFillPercentage(1, context);
      //     setHaveAnimation(true);
      //   }
      // },
      // onTapDown: (details) {
      //   if (_tempModifiedGoalCount < 1) {
      //     _updateFillPercentage(0.0, context);

      //     // }
      //   } else if (_tempModifiedGoalCount == widget.showHabit.goalCount) {
      //     _updateFillPercentage(1, context);
      //     setHaveAnimation(true);
      //   }
      // },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(20), // This matches the ClipRRect's radius
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            key: containerKey,
            height: 60,
            width: containerWidth + 20,
            decoration: BoxDecoration(
              color:
                  ensureContrastWithWhite(lightenColor(widget.showHabit.color)),
              // borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              children: [
                AnimatedContainerApp(
                  width: containerWidth * _fillPercentage,
                  color: Color(int.parse(
                      widget.showHabit.color.replaceFirst('#', '0xff'))),
                  border: 4,
                  height: 60,
                  haveAnimation: _haveAnimation,
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        textonbar(
                            text:
                                '${widget.showHabit.name}  ${widget.showHabit.id} - مقدار : ',
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
