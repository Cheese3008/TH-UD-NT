import 'package:flutter/material.dart';
import '../models/calculator_mode.dart';
import '../utils/calculator_logic.dart';
import '../utils/expression_parser.dart';

class CalculatorProvider extends ChangeNotifier {
  String _expression = '';
  String _result = '0';
  String _previousResult = '';
  String? _error;

  CalculatorMode _mode = CalculatorMode.basic;
  bool _isDegreeMode = true;
  double _memoryValue = 0;

  String get expression => _expression;
  String get result => _result;
  String get previousResult => _previousResult;
  String? get error => _error;
  CalculatorMode get mode => _mode;
  bool get isDegreeMode => _isDegreeMode;
  double get memoryValue => _memoryValue;
  bool get hasMemory => _memoryValue != 0;

  void switchMode(CalculatorMode mode) {
    _mode = mode;
    _expression = '';
    _result = '0';
    _previousResult = '';
    _error = null;
    notifyListeners();
  }

  void toggleAngleMode() {
    _isDegreeMode = !_isDegreeMode;
    notifyListeners();
  }

  void onButtonPressed(String value) {
    _error = null;

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

    if (value == 'M+') {
      memoryAdd();
      return;
    }

    if (value == 'M-') {
      memorySubtract();
      return;
    }

    if (value == 'MR') {
      memoryRecall();
      return;
    }

    if (value == 'MC') {
      memoryClear();
      return;
    }

    if (value == '2nd') {
      toggleAngleMode();
      return;
    }

    if (value == 'sin' || value == 'cos' || value == 'tan' || value == 'ln' || value == 'log') {
      _expression = '${_expression}$value(';
      notifyListeners();
      return;
    }

    if (value == '√') {
      _expression = '${_expression}√(';
      notifyListeners();
      return;
    }

    if (value == 'x²') {
      _expression = '${_expression}x²';
      notifyListeners();
      return;
    }

    if (value == 'x^y') {
      _expression = '${_expression}x^y';
      notifyListeners();
      return;
    }

    _expression = CalculatorLogic.append(_expression, value);
    notifyListeners();
  }

  void clearAll() {
    _expression = '';
    _result = '0';
    _previousResult = '';
    _error = null;
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
      final value = ExpressionParserUtil.evaluate(
        expression: _expression,
        isDegreeMode: _isDegreeMode,
      );

      _previousResult = _result;
      _result = CalculatorLogic.formatResult(value, 6);
      _error = null;
    } catch (_) {
      _error = 'Biểu thức không hợp lệ';
      _result = 'Error';
    }

    notifyListeners();
  }

  void memoryAdd() {
    final current = double.tryParse(_result) ?? 0;
    _memoryValue += current;
    notifyListeners();
  }

  void memorySubtract() {
    final current = double.tryParse(_result) ?? 0;
    _memoryValue -= current;
    notifyListeners();
  }

  void memoryRecall() {
    final recallValue = CalculatorLogic.formatResult(_memoryValue, 6);
    _expression = '${_expression}$recallValue';
    notifyListeners();
  }

  void memoryClear() {
    _memoryValue = 0;
    notifyListeners();
  }
}