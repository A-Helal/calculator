import 'package:calculator/constance.dart';
import 'package:calculator/neu_container.dart';
import 'package:flutter/material.dart';

class CalcBtn extends StatelessWidget {
  const CalcBtn({super.key,this.title,
    this.padding = 17,
    this.icon,
    this.iconColor,
    this.textColor,
    required this.onTap});


  final String? title;
  final double padding;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => onTap(title),
        child: NeuContainer(
          darkMode: Consts.darkMode,
          borderRadius: BorderRadius.circular(40),
          padding: EdgeInsets.all(padding),
          child: SizedBox(
            width: padding * 2,
            height: padding * 2,
            child: Center(
              child: title != null
                  ? Text(
                title!,
                style: TextStyle(
                    color: textColor ??
                        (Consts.darkMode ? Colors.white : Colors.black),
                    fontSize: 30),
              )
                  : Icon(icon, size: 30, color: iconColor),
            ),
          ),
        ),
      ),
    );
  }
}
