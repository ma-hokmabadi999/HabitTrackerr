import 'package:flutter/material.dart';
import './generic_dialog.dart';

Future<bool> showSameDateDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: '',
    content: 'شما قادر به تغییر روتین های پسین نیستید.',
    optionsBuilder: () => {
      'باشه': false,
    },
  ).then(
    (value) => value ?? false,
  );
}
