import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';

class DisplayArea extends StatelessWidget {
  const DisplayArea({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculatorProvider>();
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final isShort = height < 220;

        final horizontalPadding = math.max(12.0, math.min(width * 0.045, 24.0));
        final verticalPadding = math.max(10.0, math.min(height * 0.08, 20.0));

        final chipFontSize = math.max(
          11.0,
          math.min(math.min(width * 0.03, height * 0.08), 14.0),
        );

        final modeFontSize = math.max(
          11.0,
          math.min(math.min(width * 0.03, height * 0.08), 15.0),
        );

        final previousFontSize = math.max(
          14.0,
          math.min(math.min(width * 0.05, height * 0.12), 22.0),
        );

        final expressionFontSize = math.max(
          18.0,
          math.min(math.min(width * 0.08, height * 0.16), 34.0),
        );

        final resultFontSize = math.max(
          30.0,
          math.min(math.min(width * 0.15, height * 0.34), 64.0),
        );

        final gap = isShort ? 4.0 : 8.0;
        final errorHeight = isShort ? 18.0 : 22.0;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            verticalPadding,
            horizontalPadding,
            verticalPadding,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  if (provider.hasMemory)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'M',
                        style: TextStyle(
                          fontSize: chipFontSize,
                          color: theme.colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      provider.isDegreeMode ? 'DEG' : 'RAD',
                      style: TextStyle(
                        fontSize: chipFontSize,
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    provider.mode.name.toUpperCase(),
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontSize: modeFontSize,
                    ),
                  ),
                ],
              ),
              SizedBox(height: gap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (provider.previousResult.isNotEmpty)
                      Text(
                        provider.previousResult,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: previousFontSize,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    if (provider.previousResult.isNotEmpty) SizedBox(height: gap),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        provider.expression.isEmpty ? '0' : provider.expression,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: expressionFontSize,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                    ),
                    SizedBox(height: gap),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            provider.result,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: resultFontSize,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: errorHeight,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: provider.error == null
                              ? const SizedBox.shrink()
                              : Text(
                                  provider.error!,
                                  key: ValueKey(provider.error),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: theme.colorScheme.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}