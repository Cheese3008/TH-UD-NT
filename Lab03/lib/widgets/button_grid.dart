import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/calculator_mode.dart';
import '../providers/calculator_provider.dart';
import '../utils/constants.dart';
import 'calculator_button.dart';

class ButtonGrid extends StatelessWidget {
  const ButtonGrid({super.key});

  bool _isOperator(String label) {
    return ['÷', '×', '-', '+', '=', 'AND', 'OR', 'XOR', 'NOT', '<<', '>>'].contains(label);
  }

  bool _isAction(String label) {
    return ['C', 'CE', '%', '±', 'MC', 'MR', 'M+', 'M-', '2nd', 'HEX', 'DEC', 'BIN', 'OCT'].contains(label);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculatorProvider>();

    List<String> buttons;
    int columns;

    switch (provider.mode) {
      case CalculatorMode.basic:
        buttons = basicButtons;
        columns = 4;
        break;
      case CalculatorMode.scientific:
        buttons = scientificButtons;
        columns = 6;
        break;
      case CalculatorMode.programmer:
        buttons = programmerButtons;
        columns = 4;
        break;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = math.max(8.0, math.min(constraints.maxWidth * 0.02, 12.0));
        final rows = (buttons.length / columns).ceil();

        final totalHorizontalSpacing = spacing * (columns - 1);
        final totalVerticalSpacing = spacing * (rows - 1);

        final cellWidth = (constraints.maxWidth - totalHorizontalSpacing - 32) / columns;
        final cellHeight = (constraints.maxHeight - totalVerticalSpacing - 32) / rows;

        final childAspectRatio = cellWidth / cellHeight;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Padding(
            key: ValueKey(provider.mode),
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buttons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                childAspectRatio: childAspectRatio,
              ),
              itemBuilder: (context, index) {
                final label = buttons[index];

                return CalculatorButton(
                  label: label,
                  isOperator: _isOperator(label),
                  isAction: _isAction(label),
                  onTap: () => context.read<CalculatorProvider>().onButtonPressed(label),
                );
              },
            ),
          ),
        );
      },
    );
  }
}