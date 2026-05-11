import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../providers/audio_provider.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Consumer<AudioProvider>(
        builder: (context, provider, child) {
          return ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const Text(
                'Cài đặt',
                style: TextStyle(color: AppColors.text, fontSize: 32, height: 1, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              const Text('Tùy chỉnh trải nghiệm nghe nhạc', style: TextStyle(color: AppColors.mutedText)),
              const SizedBox(height: 20),
              _buildVolumeCard(provider),
              const SizedBox(height: 12),
              _buildSwitchCard(
                icon: Icons.shuffle_rounded,
                title: 'Phát ngẫu nhiên',
                subtitle: 'Tự động chọn bài tiếp theo theo thứ tự ngẫu nhiên',
                value: provider.isShuffleEnabled,
                onChanged: (_) => provider.toggleShuffle(),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                icon: _repeatIcon(provider.loopMode),
                title: 'Chế độ lặp',
                subtitle: _repeatText(provider.loopMode),
                onTap: provider.toggleRepeat,
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                icon: Icons.phone_android_rounded,
                title: 'Gợi ý kiểm thử',
                subtitle: 'Nên chạy trên thiết bị Android thật. Có thể dùng nút Import ở màn hình Bài hát để chọn file audio thủ công.',
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _buildInfoPanel(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVolumeCard(AudioProvider provider) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildIconBox(Icons.volume_up_rounded),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Âm lượng', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text('${(provider.volume * 100).round()}%', style: const TextStyle(color: AppColors.mutedText)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 5,
              activeTrackColor: AppColors.secondary,
              inactiveTrackColor: AppColors.border,
              thumbColor: AppColors.text,
              overlayColor: AppColors.secondary.withOpacity(0.2),
            ),
            child: Slider(
              value: provider.volume,
              min: 0,
              max: 1,
              divisions: 10,
              label: '${(provider.volume * 100).round()}%',
              onChanged: provider.setVolume,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: _cardDecoration(),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        value: value,
        onChanged: onChanged,
        secondary: _buildIconBox(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.mutedText)),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: _cardDecoration(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              children: [
                _buildIconBox(icon),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: const TextStyle(color: AppColors.mutedText)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.mutedText),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPanel() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppGradients.primary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppShadows.soft,
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome_rounded, color: Colors.white),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'UI đã được bố trí lại theo hướng dashboard hiện đại: thư viện, playlist, mini player, màn hình phát nhạc và cài đặt đều tách rõ chức năng.',
              style: TextStyle(color: Colors.white, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.surface.withOpacity(0.88),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.border),
    );
  }

  Widget _buildIconBox(IconData icon) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.16),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: AppColors.secondary),
    );
  }

  IconData _repeatIcon(LoopMode mode) {
    if (mode == LoopMode.one) {
      return Icons.repeat_one_rounded;
    }
    return Icons.repeat_rounded;
  }

  String _repeatText(LoopMode mode) {
    switch (mode) {
      case LoopMode.off:
        return 'Đang tắt';
      case LoopMode.all:
        return 'Lặp toàn bộ playlist';
      case LoopMode.one:
        return 'Lặp bài hát hiện tại';
    }
  }
}
