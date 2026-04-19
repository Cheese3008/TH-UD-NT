import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/button_grid.dart';
import '../widgets/display_area.dart';

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
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;

            // Giới hạn chiều rộng calculator để desktop/web không bị quá bè ngang
            final calculatorWidth = math.min(
              screenWidth - 24,
              screenWidth < 600 ? screenWidth - 24 : 520.0,
            );

            return Center(
              child: SizedBox(
                width: calculatorWidth,
                height: screenHeight,
                child: const Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DisplayArea(),
                    ),
                    Expanded(
                      flex: 3,
                      child: ButtonGrid(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}