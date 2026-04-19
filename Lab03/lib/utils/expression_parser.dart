import 'package:math_expressions/math_expressions.dart';

class ExpressionParserUtil {
  static double evaluate({
    required String expression,
    required bool isDegreeMode,
  }) {
    String normalized = expression
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('π', 'pi')
        .replaceAll('√', 'sqrt')
        .replaceAll('x²', '^2')
        .replaceAll('x^y', '^')
        .replaceAll('ln', 'ln')
        .replaceAll('log', 'log')
        .replaceAll('%', '/100');

    normalized = _insertImplicitMultiplication(normalized);

    if (isDegreeMode) {
      normalized = _convertTrigDegrees(normalized);
    }

    final parser = Parser();
    final exp = parser.parse(normalized);
    final context = ContextModel();

    return exp.evaluate(EvaluationType.REAL, context);
  }

  static String _insertImplicitMultiplication(String input) {
    return input
        .replaceAllMapped(RegExp(r'(\d)(pi)'), (m) => '${m[1]}*${m[2]}')
        .replaceAllMapped(RegExp(r'(\d)(sqrt)'), (m) => '${m[1]}*${m[2]}')
        .replaceAllMapped(RegExp(r'(\))(\d)'), (m) => '${m[1]}*${m[2]}')
        .replaceAllMapped(RegExp(r'(\))(\()'), (m) => '${m[1]}*${m[2]}');
  }

  static String _convertTrigDegrees(String input) {
    input = input.replaceAllMapped(
      RegExp(r'sin\(([^()]+)\)'),
      (m) => 'sin((${m[1]})*pi/180)',
    );
    input = input.replaceAllMapped(
      RegExp(r'cos\(([^()]+)\)'),
      (m) => 'cos((${m[1]})*pi/180)',
    );
    input = input.replaceAllMapped(
      RegExp(r'tan\(([^()]+)\)'),
      (m) => 'tan((${m[1]})*pi/180)',
    );
    return input;
  }
}