import 'package:flutter/material.dart';

void main()
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pastel Calculator',
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget
{
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
{
  String display = '0';
  String equation = '';
  double num1 = 0;
  double num2 = 0;
  String operation = '';
  bool shouldResetDisplay = false;

  final Color backgroundColor = const Color(0xFFF8F4FF);
  final Color panelColor = const Color(0xFFF1EAFB);
  final Color displayColor = const Color(0xFFFFFFFF);
  final Color numberButtonColor = const Color(0xFFDDEAF4);
  final Color operatorButtonColor = const Color(0xFFD8C2F3);
  final Color actionButtonColor = const Color(0xFFF7C9B8);
  final Color textPrimary = const Color(0xFF505070);
  final Color textSecondary = const Color(0xFF8A89A6);
  final Color shadowColor = const Color(0x14000000);

  void onButtonPressed(String value)
  {
    setState(() {
      if (value == 'C')
      {
        clearAll();
      }
      else if (value == 'CE')
      {
        clearEntry();
      }
      else if (value == '±')
      {
        toggleSign();
      }
      else if (value == '%')
      {
        calculatePercent();
      }
      else if (value == '.')
      {
        addDecimal();
      }
      else if (
        value == '+' ||
        value == '-' ||
        value == '×' ||
        value == '÷'
      )
      {
        setOperation(value);
      }
      else if (value == '=')
      {
        calculateResult();
      }
      else
      {
        appendNumber(value);
      }
    });
  }

  void clearAll()
  {
    display = '0';
    equation = '';
    num1 = 0;
    num2 = 0;
    operation = '';
    shouldResetDisplay = false;
  }

  void clearEntry()
  {
    if (display == 'Error')
    {
      display = '0';
      return;
    }

    if (display.length > 1)
    {
      display = display.substring(0, display.length - 1);

      if (display == '-' || display.isEmpty)
      {
        display = '0';
      }
    }
    else
    {
      display = '0';
    }
  }

  void toggleSign()
  {
    if (display == '0' || display == 'Error')
    {
      return;
    }

    if (display.startsWith('-'))
    {
      display = display.substring(1);
    }
    else
    {
      display = '-$display';
    }
  }

  void calculatePercent()
  {
    if (display == 'Error')
    {
      return;
    }

    final double value = double.tryParse(display) ?? 0;
    display = formatNumber(value / 100);
  }

  void addDecimal()
  {
    if (display == 'Error')
    {
      display = '0.';
      shouldResetDisplay = false;
      return;
    }

    if (shouldResetDisplay)
    {
      display = '0.';
      shouldResetDisplay = false;
      return;
    }

    if (!display.contains('.'))
    {
      display += '.';
    }
  }

  void appendNumber(String value)
  {
    if (display == 'Error')
    {
      display = value;
      return;
    }

    if (shouldResetDisplay)
    {
      display = value;
      shouldResetDisplay = false;
      return;
    }

    if (display == '0')
    {
      display = value;
    }
    else if (display.length < 16)
    {
      display += value;
    }
  }

  void setOperation(String op)
  {
    if (display == 'Error')
    {
      return;
    }

    if (operation.isNotEmpty && !shouldResetDisplay)
    {
      calculateResult();
    }

    num1 = double.tryParse(display) ?? 0;
    operation = op;
    equation = '${formatNumber(num1)} $operation';
    shouldResetDisplay = true;
  }

  void calculateResult()
  {
    if (operation.isEmpty || display == 'Error')
    {
      return;
    }

    num2 = double.tryParse(display) ?? 0;
    double result = 0;

    if (operation == '+')
    {
      result = num1 + num2;
    }
    else if (operation == '-')
    {
      result = num1 - num2;
    }
    else if (operation == '×')
    {
      result = num1 * num2;
    }
    else if (operation == '÷')
    {
      if (num2 == 0)
      {
        display = 'Error';
        equation = 'Cannot divide by zero';
        operation = '';
        shouldResetDisplay = true;
        return;
      }

      result = num1 / num2;
    }

    equation = '${formatNumber(num1)} $operation ${formatNumber(num2)} =';
    display = formatNumber(result);
    num1 = result;
    operation = '';
    shouldResetDisplay = true;
  }

  String formatNumber(double number)
  {
    if (number % 1 == 0)
    {
      return number.toInt().toString();
    }

    String text = number.toStringAsFixed(8);
    text = text.replaceAll(RegExp(r'0+$'), '');
    text = text.replaceAll(RegExp(r'\.$'), '');
    return text;
  }

  Widget buildCalcButton(
    String text,
    {
      required Color backgroundColor,
      required Color textColor,
      IconData? icon,
    }
  )
  {
    return SizedBox(
      width: double.infinity,
      height: 74,
      child: ElevatedButton(
        onPressed: () => onButtonPressed(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: icon != null
            ? Icon(icon, size: 28)
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget buildButtonRow(List<Widget> children)
  {
    return Expanded(
      child: Row(
        children: [
          Expanded(child: children[0]),
          const SizedBox(width: 14),
          Expanded(child: children[1]),
          const SizedBox(width: 14),
          Expanded(child: children[2]),
          const SizedBox(width: 14),
          Expanded(child: children[3]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 28,
              left: 40,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8DDF8).withOpacity(0.55),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 140,
              right: 70,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFD8EEF5).withOpacity(0.55),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 140,
              left: 70,
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 28,
                color: const Color(0xFFCDB4F7).withOpacity(0.65),
              ),
            ),
            Positioned(
              top: 70,
              right: 120,
              child: Icon(
                Icons.favorite_rounded,
                size: 22,
                color: const Color(0xFFF7C9B8).withOpacity(0.75),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Expanded(
                    flex: 32,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: panelColor,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5D8F7),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calculate_rounded,
                                  size: 18,
                                  color: textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Calculator',
                                  style: TextStyle(
                                    color: textSecondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                constraints: const BoxConstraints(
                                  minHeight: 110,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: displayColor,
                                  borderRadius: BorderRadius.circular(26),
                                  boxShadow: [
                                    BoxShadow(
                                      color: shadowColor,
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      reverse: true,
                                      child: Text(
                                        equation.isEmpty ? ' ' : equation,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: textSecondary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        display,
                                        maxLines: 1,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: textPrimary,
                                          fontSize: 46,
                                          fontWeight: FontWeight.bold,
                                          height: 1.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 14,
                                right: 14,
                                child: Icon(
                                  Icons.auto_awesome_rounded,
                                  size: 20,
                                  color: const Color(0xFFF7C9B8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    flex: 58,
                    child: Column(
                      children: [
                        buildButtonRow([
                          buildCalcButton(
                            'C',
                            backgroundColor: actionButtonColor,
                            textColor: textPrimary,
                            icon: Icons.refresh_rounded,
                          ),
                          buildCalcButton(
                            'CE',
                            backgroundColor: actionButtonColor,
                            textColor: textPrimary,
                            icon: Icons.backspace_outlined,
                          ),
                          buildCalcButton(
                            '%',
                            backgroundColor: operatorButtonColor,
                            textColor: textPrimary,
                            icon: Icons.percent_rounded,
                          ),
                          buildCalcButton(
                            '÷',
                            backgroundColor: operatorButtonColor,
                            textColor: textPrimary,
                          ),
                        ]),
                        const SizedBox(height: 14),
                        buildButtonRow([
                          buildCalcButton(
                            '7',
                            backgroundColor: numberButtonColor,
                            textColor: textPrimary,
                          ),
                          buildCalcButton(
                            '8',
                            backgroundColor: numberButtonColor,
                            textColor: textPrimary,
                          ),
                          buildCalcButton(
                            '9',
                            backgroundColor: numberButtonColor,
                            textColor: textPrimary,
                          ),
                          buildCalcButton(
                            '×',
                            backgroundColor: operatorButtonColor,
                            textColor: textPrimary,
                          ),
                        ]),
                        const SizedBox(height: 14),
                        buildButtonRow([
                          buildCalcButton(
                            '4',
                            backgroundColor: numberButtonColor,
                            textColor: textPrimary,
                          ),
                          buildCalcButton(
                            '5',
                            backgroundColor: numberButtonColor,
                            textColor: textPrimary,
                          ),
                          buildCalcButton(
                            '6',
                            backgroundColor: numberButtonColor,
                            textColor: textPrimary,
                          ),
                          buildCalcButton(
                            '-',
                            backgroundColor: operatorButtonColor,
                            textColor: textPrimary,
                          ),
                        ]),
                        const SizedBox(height: 14),
                        buildButtonRow([
                          buildCalcButton(
                            '1',
                            backgroundColor: numberButtonColor,
                            textColor: textPrimary,
                          ),
                          buildCalcButton(
                            '2',
                            backgroundColor: numberButtonColor,
                            textColor: textPrimary,
                          ),
                          buildCalcButton(
                            '3',
                            backgroundColor: numberButtonColor,
                            textColor: textPrimary,
                          ),
                          buildCalcButton(
                            '+',
                            backgroundColor: operatorButtonColor,
                            textColor: textPrimary,
                          ),
                        ]),
                        const SizedBox(height: 14),
                        buildButtonRow([
                          buildCalcButton(
                            '±',
                            backgroundColor: numberButtonColor,
                            textColor: textPrimary,
                          ),
                          buildCalcButton(
                            '0',
                            backgroundColor: numberButtonColor,
                            textColor: textPrimary,
                          ),
                          buildCalcButton(
                            '.',
                            backgroundColor: numberButtonColor,
                            textColor: textPrimary,
                          ),
                          buildCalcButton(
                            '=',
                            backgroundColor: actionButtonColor,
                            textColor: textPrimary,
                          ),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}