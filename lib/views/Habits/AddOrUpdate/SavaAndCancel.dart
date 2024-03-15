import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SaveAndCancel extends StatelessWidget {
  final Function() saveHabit;
  const SaveAndCancel({
    super.key,
    required this.saveHabit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .center, // Centers the buttons with space in between
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // Simply navigate back to the previous page
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  'انصراف',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () async {
              saveHabit();
            },
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text('ذخیره',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
