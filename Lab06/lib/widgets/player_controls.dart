import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../providers/audio_provider.dart';
import '../utils/constants.dart';

class PlayerControls extends StatelessWidget {
  final AudioProvider provider;

  const PlayerControls({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildModeButton(
              icon: Icons.shuffle_rounded,
              active: provider.isShuffleEnabled,
              onPressed: provider.toggleShuffle,
            ),
            const SizedBox(width: 16),
            _buildRepeatButton(),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCircleButton(
              icon: Icons.skip_previous_rounded,
              size: 58,
              iconSize: 34,
              onPressed: provider.previous,
            ),
            const SizedBox(width: 22),
            StreamBuilder<bool>(
              stream: provider.playingStream,
              builder: (context, snapshot) {
                final isPlaying = snapshot.data ?? false;
                return Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    gradient: AppGradients.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.35),
                        blurRadius: 28,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 46,
                    ),
                    onPressed: provider.playPause,
                  ),
                );
              },
            ),
            const SizedBox(width: 22),
            _buildCircleButton(
              icon: Icons.skip_next_rounded,
              size: 58,
              iconSize: 34,
              onPressed: provider.next,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModeButton({
    required IconData icon,
    required bool active,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: active ? AppColors.primary.withOpacity(0.18) : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: active ? AppColors.primary : AppColors.border),
      ),
      child: IconButton(
        icon: Icon(icon, color: active ? AppColors.secondary : AppColors.mutedText),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required double size,
    required double iconSize,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.92),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.text, size: iconSize),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildRepeatButton() {
    IconData icon;
    bool active;

    switch (provider.loopMode) {
      case LoopMode.off:
        icon = Icons.repeat_rounded;
        active = false;
        break;
      case LoopMode.all:
        icon = Icons.repeat_rounded;
        active = true;
        break;
      case LoopMode.one:
        icon = Icons.repeat_one_rounded;
        active = true;
        break;
    }

    return _buildModeButton(
      icon: icon,
      active: active,
      onPressed: provider.toggleRepeat,
    );
  }
}
