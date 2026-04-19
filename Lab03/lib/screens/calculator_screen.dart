import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../widgets/button_grid.dart';
import '../widgets/display_area.dart';
import '../widgets/mode_selector.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Calculator'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final calculatorWidth = math.min(
              constraints.maxWidth - 24,
              constraints.maxWidth < 600 ? constraints.maxWidth - 24 : 560.0,
            );

            final isShortHeight = constraints.maxHeight < 760;

            return Consumer<CalculatorProvider>(
              builder: (context, provider, child) {
                final displayFlex = isShortHeight ? 2 : 3;
                final buttonFlex = provider.mode.name == 'scientific'
                    ? (isShortHeight ? 5 : 6)
                    : (isShortHeight ? 4 : 5);

                return Center(
                  child: SizedBox(
                    width: calculatorWidth,
                    child: Column(
                      children: [
                        const ModeSelector(),
                        Expanded(
                          flex: displayFlex,
                          child: const DisplayArea(),
                        ),
                        Expanded(
                          flex: buttonFlex,
                          child: const ButtonGrid(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}