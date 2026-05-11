import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/duration_formatter.dart';

class ProgressBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration> onSeek;

  const ProgressBar({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    final maxMilliseconds = duration.inMilliseconds <= 0 ? 1.0 : duration.inMilliseconds.toDouble();
    final currentMilliseconds = position.inMilliseconds.clamp(0, maxMilliseconds.toInt()).toDouble();

    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 5,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
            activeTrackColor: AppColors.secondary,
            inactiveTrackColor: AppColors.border,
            thumbColor: AppColors.text,
            overlayColor: AppColors.secondary.withOpacity(0.22),
          ),
          child: Slider(
            value: currentMilliseconds,
            min: 0,
            max: maxMilliseconds,
            onChanged: (value) => onSeek(Duration(milliseconds: value.toInt())),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatDuration(position), style: const TextStyle(color: AppColors.mutedText, fontSize: 12)),
              Text(formatDuration(duration), style: const TextStyle(color: AppColors.mutedText, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
