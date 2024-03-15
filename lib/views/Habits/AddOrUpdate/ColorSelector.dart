// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorSelector extends StatelessWidget {
  final Color labelColor;
  final double textFieldWidth;
  final List colors;
  final String selectedColor;
  final Function(int) setSelectedColor;

  const ColorSelector({
    super.key,
    required this.labelColor,
    required this.colors,
    required this.selectedColor,
    required this.textFieldWidth,
    required this.setSelectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4, bottom: 8, right: 3),
            child: Text(
              "انتخاب رنگ",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: labelColor),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: colors.length, // Number of colors
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            8, // Increase for more columns, making items smaller
                        childAspectRatio:
                            1, // Aspect ratio of 1 keeps items square
                        crossAxisSpacing:
                            10, // Reduce spacing for smaller items
                        mainAxisSpacing: 10, // Reduce spacing for smaller items
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        // Example color list, replace with your own list of colors

                        return InkWell(
                          onTap: () {
                            setSelectedColor(index);
                            Navigator.pop(context); // Close the bottom sheet
                          },
                          child: Container(
                            margin: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Color(int.parse(
                                  colors[index % colors.length].replaceFirst(
                                      '#', '0xff'))), // Color of the container
                              borderRadius: BorderRadius.circular(
                                  20), // Optional: makes the containers slightly rounded
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
            child: Container(
              height: 25,
              width: 100,
              margin: EdgeInsets.only(right: 10, bottom: 8),
              padding: EdgeInsets.only(top: 0),
              decoration: BoxDecoration(
                color: Color(int.parse(selectedColor.replaceFirst(
                    '#', '0xff'))), // Use the selected color for container
                borderRadius: BorderRadius.circular(4),
              ),
              child: SizedBox(
                height: 30,
                width: textFieldWidth * .1,
              ),
            ),
          )
        ],
      ),
    );
  }
}
