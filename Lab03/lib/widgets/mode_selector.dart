import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/calculator_mode.dart';
import '../providers/calculator_provider.dart';

class ModeSelector extends StatelessWidget {
  const ModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculatorProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 420;

        return Padding(
          padding: EdgeInsets.fromLTRB(16, isCompact ? 6 : 10, 16, 4),
          child: SegmentedButton<CalculatorMode>(
            showSelectedIcon: !isCompact,
            style: ButtonStyle(
              visualDensity: isCompact
                  ? const VisualDensity(horizontal: -1, vertical: -2)
                  : const VisualDensity(horizontal: 0, vertical: 0),
            ),
            segments: [
              ButtonSegment(
                value: CalculatorMode.basic,
                label: Text(isCompact ? 'Basic' : 'Basic'),
              ),
              ButtonSegment(
                value: CalculatorMode.scientific,
                label: Text(isCompact ? 'Sci' : 'Scientific'),
              ),
              ButtonSegment(
                value: CalculatorMode.programmer,
                label: Text(isCompact ? 'Prog' : 'Programmer'),
              ),
            ],
            selected: {provider.mode},
            onSelectionChanged: (selected) {
              provider.switchMode(selected.first);
            },
          ),
        );
      },
    );
  }
}