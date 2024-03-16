import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
}) {
  final options = optionsBuilder();
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
        ),
        titlePadding: EdgeInsets.fromLTRB(
            0, 0, 0, 0), // Adjust title padding here, set top to 0 for no space
        content: Text(
          content,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        contentPadding: EdgeInsets.fromLTRB(
            20, 0, 20, 28), // Adjust content padding as needed
        buttonPadding: EdgeInsets.all(0), // Minimal button padding
        actionsPadding: EdgeInsets.symmetric(horizontal: 0), // Adjust as needed
        actions: options.keys.map((optionTitle) {
          final value = options[optionTitle];
          return TextButton(
            onPressed: () {
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(optionTitle),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                  horizontal: 16.0), // Adjust button internal padding if needed
            ),
          );
        }).toList(),
        actionsAlignment: MainAxisAlignment
            .spaceBetween, // Adjust the alignment of actions if necessary
      );
    },
  );
}
