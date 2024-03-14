import 'package:flutter/material.dart';

class CounterModel with ChangeNotifier {
  bool _count = false;

  bool get count => _count;

  void getStatus(bool status) {
    _count = status;
    print(status);

    notifyListeners(); // Notify all the listeners of a change.
  }
}
