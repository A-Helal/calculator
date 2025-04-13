import 'package:calculator/constance.dart';
import 'package:calculator/neu_container.dart';
import 'package:calculator/widgets/calc_btn.dart';
import 'package:calculator/widgets/calc_trigonometric_functions.dart';
import 'package:calculator/widgets/switch_mode.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String expression = '';
  String result = '0';
  bool hasCalculated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Consts.darkMode ? colorDark : colorLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Consts.darkMode = !Consts.darkMode;
                      });
                    },
                    child: const SwitchMode(),
                  ),
                  const SizedBox(height: 80),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          expression.isEmpty ? '0' : expression,
                          style: TextStyle(
                            fontSize: 55,
                            fontWeight: FontWeight.bold,
                            color:
                                Consts.darkMode ? Colors.white : Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          result,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: Consts.darkMode ? Colors.green : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10)
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CalcTrigonometricFunctions(
                        title: "sin",
                        onTap: (_) => onTrigFunctionClicked('sin'),
                      ),
                      CalcTrigonometricFunctions(
                        title: "cos",
                        onTap: (_) => onTrigFunctionClicked('cos'),
                      ),
                      CalcTrigonometricFunctions(
                        title: "tan",
                        onTap: (_) => onTrigFunctionClicked('tan'),
                      ),
                      CalcTrigonometricFunctions(
                        title: "%",
                        onTap: onOperatorClicked,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CalcBtn(
                        onTap: (_) => onClearAllClicked(),
                        title: "C",
                        textColor:
                            Consts.darkMode ? Colors.green : Colors.redAccent,
                      ),
                      CalcBtn(title: '(', onTap: onBtnClicked),
                      CalcBtn(title: ')', onTap: onBtnClicked),
                      CalcBtn(
                        onTap: onOperatorClicked,
                        title: '/',
                        textColor:
                            Consts.darkMode ? Colors.green : Colors.redAccent,
                      ),
                    ],
                  ),
                  ..._buildNumberRows(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CalcBtn(
                        title: "0",
                        onTap: onBtnClicked,
                      ),
                      CalcBtn(
                        title: ".",
                        onTap: onBtnClicked,
                      ),
                      CalcBtn(
                        onTap: (_) => onDeleteClicked(),
                        icon: Icons.backspace_outlined,
                        iconColor:
                            Consts.darkMode ? Colors.green : Colors.redAccent,
                      ),
                      CalcBtn(
                        onTap: (_) => onEqualClicked(),
                        title: '=',
                        textColor:
                            Consts.darkMode ? Colors.green : Colors.redAccent,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNumberRows() {
    List<List<String>> numbers = [
      ["7", "8", "9"],
      ["4", "5", "6"],
      ["1", "2", "3"],
    ];
    return numbers.map((row) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            row.map((n) => CalcBtn(title: n, onTap: onBtnClicked)).toList()
              ..add(
                CalcBtn(
                  onTap: onOperatorClicked,
                  title: row == numbers[0]
                      ? "×"
                      : row == numbers[1]
                          ? "-"
                          : "+",
                  textColor: Consts.darkMode ? Colors.green : Colors.redAccent,
                ),
              ),
      );
    }).toList();
  }

  void onTrigFunctionClicked(String function) {
    if (hasCalculated) {
      try {
        double value = double.parse(result);
        double radians = value * (pi / 180);
        double functionResult;

        switch (function) {
          case 'sin':
            functionResult = sin(radians);
            break;
          case 'cos':
            functionResult = cos(radians);
            break;
          case 'tan':
            functionResult = tan(radians);
            break;
          default:
            return;
        }

        expression = '$function($result°)';
        result = functionResult.toStringAsFixed(4);
      } catch (e) {
        result = 'Error';
      }
    } else {
      if (expression.isNotEmpty) {
        onEqualClicked();
        onTrigFunctionClicked(function);
        return;
      }

      // Default to 0 if no expression
      expression = '$function(0°)';
      result = '0.0000';
    }

    hasCalculated = true;
    setState(() {});
  }

  void onBtnClicked(String text) {
    if (hasCalculated) {
      expression = text;
      result = '0';
      hasCalculated = false;
    } else {
      expression += text;
    }
    setState(() {});
  }

  void onEqualClicked() {
    if (expression.isEmpty) return;

    try {
      String expressionToParse =
          expression.replaceAll('×', '*').replaceAll('÷', '/');

      // Handle percentage operations
      expressionToParse = expressionToParse.replaceAll('%', '/100');

      Parser parser = Parser();
      Expression exp = parser.parse(expressionToParse);
      ContextModel contextModel = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, contextModel);

      if (eval == eval.roundToDouble()) {
        result = eval.toInt().toString();
      } else {
        result = eval.toString();
      }
    } catch (e) {
      result = 'Error';
    }

    hasCalculated = true;
    setState(() {});
  }

  void onOperatorClicked(String text) {
    if (expression.isEmpty && result != '0' && result != 'Error') {
      expression = result;
    } else if (expression.isEmpty) {
      expression = '0';
    }

    if (hasCalculated) {
      expression = result + text;
      result = '0';
      hasCalculated = false;
    } else {
      String lastChar =
          expression.isNotEmpty ? expression[expression.length - 1] : '';
      if (['+', '-', '×', '/', '%'].contains(lastChar)) {
        expression = expression.substring(0, expression.length - 1) + text;
      } else {
        // Add the operator
        expression += text;
      }
    }

    setState(() {});
  }

  void onDeleteClicked() {
    if (hasCalculated) {
      onClearAllClicked();
    } else if (expression.isNotEmpty) {
      expression = expression.substring(0, expression.length - 1);
      setState(() {});
    }
  }

  void onClearAllClicked() {
    expression = '';
    result = '0';
    hasCalculated = false;
    setState(() {});
  }
}
