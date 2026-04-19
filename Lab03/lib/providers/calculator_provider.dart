import 'package:flutter/material.dart';
import '../models/calculator_mode.dart';
import '../utils/calculator_logic.dart';
import '../utils/expression_parser.dart';

class CalculatorProvider extends ChangeNotifier {
  String _expression = '';
  String _result = '0';
  CalculatorMode _mode = CalculatorMode.basic;

  String get expression => _expression;
  String get result => _result;
  CalculatorMode get mode => _mode;

  void onButtonPressed(String value) {
    if (value == 'C') {
      clearAll();
      return;
    }

    if (value == 'CE') {
      clearEntry();
      return;
    }

    if (value == '=') {
      calculate();
      return;
    }

    if (value == '±') {
      toggleSign();
      return;
    }

    _expression = CalculatorLogic.append(_expression, value);
    notifyListeners();
  }

  void switchMode(CalculatorMode mode) {
    _mode = mode;
    notifyListeners();
  }

  void clearAll() {
    _expression = '';
    _result = '0';
    notifyListeners();
  }

  void clearEntry() {
    _expression = CalculatorLogic.deleteLast(_expression);
    notifyListeners();
  }

  void toggleSign() {
    _expression = CalculatorLogic.toggleSign(_expression);
    notifyListeners();
  }

  void calculate() {
    if (_expression.trim().isEmpty) {
      return;
    }

    try {
      final value = ExpressionParserUtil.evaluate(_expression);
      _result = CalculatorLogic.formatResult(value, 6);
    } catch (_) {
      _result = 'Error';
    }

    notifyListeners();
  }
}