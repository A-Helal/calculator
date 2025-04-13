import 'package:calculator/constance.dart';
import 'package:calculator/neu_container.dart';
import 'package:flutter/material.dart';

class CalcTrigonometricFunctions extends StatelessWidget {
  const CalcTrigonometricFunctions(
      {super.key, required this.title, required this.onTap});

  final String title;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () => onTap(title),
        child: NeuContainer(
          darkMode: Consts.darkMode,
          borderRadius: BorderRadius.circular(50),
          padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8.5),
          child: SizedBox(
            width: 17 * 2,
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                    color: Consts.darkMode ? Colors.white : Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
