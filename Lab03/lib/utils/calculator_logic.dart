class CalculatorLogic {
  static String append(String current, String value) {
    if (value == '.') {
      final lastNumber = _getLastNumberSegment(current);
      if (lastNumber.contains('.')) {
        return current;
      }
      if (lastNumber.isEmpty) {
        return '${current}0.';
      }
    }

    if (current.isEmpty && ['+', '×', '÷', '%'].contains(value)) {
      return current;
    }

    return '$current$value';
  }

  static String deleteLast(String current) {
    if (current.isEmpty) {
      return '';
    }
    return current.substring(0, current.length - 1);
  }

  static String toggleSign(String current) {
    if (current.isEmpty) {
      return current;
    }

    if (current.startsWith('-')) {
      return current.substring(1);
    }

    return '-$current';
  }

  static String formatResult(double value, int precision) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }

    return value
        .toStringAsFixed(precision)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  static String _getLastNumberSegment(String expression) {
    final parts = expression.split(RegExp(r'[\+\-\×\÷\%\(\)]'));
    if (parts.isEmpty) {
      return '';
    }
    return parts.last;
  }
}