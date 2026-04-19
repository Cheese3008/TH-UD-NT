import 'dart:math' as math;
import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isOperator;
  final bool isAction;

  const CalculatorButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isOperator = false,
    this.isAction = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color backgroundColor;
    Color foregroundColor;

    if (isOperator) {
      backgroundColor = theme.colorScheme.primary;
      foregroundColor = theme.colorScheme.onPrimary;
    } else if (isAction) {
      backgroundColor = theme.colorScheme.secondaryContainer;
      foregroundColor = theme.colorScheme.onSecondaryContainer;
    } else {
      backgroundColor = theme.colorScheme.surfaceContainerHighest;
      foregroundColor = theme.colorScheme.onSurface;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final shortestSide = math.min(
          constraints.maxWidth,
          constraints.maxHeight,
        );

        final fontSize = math.max(22.0, math.min(shortestSide * 0.28, 34.0));
        final radius = math.max(18.0, math.min(shortestSide * 0.22, 28.0));

        return Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(radius),
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: onTap,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: foregroundColor,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}