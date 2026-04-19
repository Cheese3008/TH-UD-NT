import 'package:math_expressions/math_expressions.dart';

class ExpressionParserUtil {
  static double evaluate(String expression) {
    String normalized = expression
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('π', 'pi')
        .replaceAll('−', '-')
        .replaceAll('%', '/100');

    final parser = Parser();
    final exp = parser.parse(normalized);
    final contextModel = ContextModel();

    return exp.evaluate(EvaluationType.REAL, contextModel);
  }
}