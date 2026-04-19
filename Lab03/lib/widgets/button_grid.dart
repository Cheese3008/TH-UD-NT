import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../utils/constants.dart';
import 'calculator_button.dart';

class ButtonGrid extends StatelessWidget {
  const ButtonGrid({super.key});

  bool _isOperator(String label) {
    return ['÷', '×', '-', '+', '='].contains(label);
  }

  bool _isAction(String label) {
    return ['C', 'CE', '%', '±'].contains(label);
  }

  @override
  Widget build(BuildContext context) {
    final calculatorProvider = context.read<CalculatorProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        const columns = 4;
        const rows = 5;

        final spacing = math.max(
          8.0,
          math.min(constraints.maxWidth * 0.025, 16.0),
        );

        final totalHorizontalSpacing = spacing * (columns - 1);
        final totalVerticalSpacing = spacing * (rows - 1);

        final cellWidth =
            (constraints.maxWidth - totalHorizontalSpacing - 16 * 2) / columns;
        final cellHeight =
            (constraints.maxHeight - totalVerticalSpacing - 16 * 2) / rows;

        final childAspectRatio = cellWidth / cellHeight;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: basicButtons.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              final buttonLabel = basicButtons[index];

              return CalculatorButton(
                label: buttonLabel,
                isOperator: _isOperator(buttonLabel),
                isAction: _isAction(buttonLabel),
                onTap: () {
                  calculatorProvider.onButtonPressed(buttonLabel);
                },
              );
            },
          ),
        );
      },
    );
  }
}