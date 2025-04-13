import 'package:calculator/constance.dart';
import 'package:calculator/neu_container.dart';
import 'package:flutter/material.dart';

class SwitchMode extends StatelessWidget {
  const SwitchMode({super.key});

  @override
  Widget build(BuildContext context) {
    return NeuContainer(
      darkMode: Consts.darkMode,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      borderRadius: BorderRadius.circular(40),
      child: SizedBox(
        width: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.wb_sunny,
              color: Consts.darkMode ? Colors.grey : Colors.redAccent,
            ),
            Icon(
              Icons.nightlight_round,
              color: Consts.darkMode ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
