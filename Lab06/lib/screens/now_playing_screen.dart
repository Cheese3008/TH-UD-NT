import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song_model.dart';
import '../providers/audio_provider.dart';
import '../utils/constants.dart';
import '../widgets/album_art.dart';
import '../widgets/player_controls.dart';
import '../widgets/progress_bar.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.background),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Consumer<AudioProvider>(
          builder: (context, provider, child) {
            final song = provider.currentSong;
            if (song == null) {
              return const SafeArea(
                child: Center(
                  child: Text('Chưa phát bài hát nào', style: TextStyle(color: AppColors.text)),
                ),
              );
            }

            return SafeArea(
              child: Column(
                children: [
                  _buildAppBar(context),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 26),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          _buildAlbumSection(song),
                          const SizedBox(height: 30),
                          _buildSongInfo(song),
                          const SizedBox(height: 24),
                          _buildProgress(provider),
                          const SizedBox(height: 26),
                          PlayerControls(provider: provider),
                          const SizedBox(height: 24),
                          _buildQueueInfo(provider),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      child: Row(
        children: [
          _buildTopButton(
            icon: Icons.keyboard_arrow_down_rounded,
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Column(
              children: [
                Text(
                  'Đang phát',
                  style: TextStyle(color: AppColors.text, fontSize: 16, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 3),
                Text('Offline Player', style: TextStyle(color: AppColors.mutedText, fontSize: 12)),
              ],
            ),
          ),
          _buildTopButton(
            icon: Icons.more_horiz_rounded,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTopButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.82),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.text),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildAlbumSection(SongModel song) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.primary.withOpacity(0.28),
                AppColors.secondary.withOpacity(0.05),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.72),
            borderRadius: BorderRadius.circular(38),
            border: Border.all(color: AppColors.border),
          ),
          child: AlbumArt(song: song, size: 250, borderRadius: 30),
        ),
      ],
    );
  }

  Widget _buildSongInfo(SongModel song) {
    return Column(
      children: [
        Text(
          song.title,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 25,
            height: 1.15,
            fontWeight: FontWeight.w900,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          song.artist,
          style: const TextStyle(color: AppColors.mutedText, fontSize: 15),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildProgress(AudioProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 16, 6, 14),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.72),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: StreamBuilder(
        stream: provider.playbackStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          return ProgressBar(
            position: state?.position ?? Duration.zero,
            duration: state?.duration ?? Duration.zero,
            onSeek: provider.seek,
          );
        },
      ),
    );
  }

  Widget _buildQueueInfo(AudioProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.72),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.format_list_bulleted_rounded, color: AppColors.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Hàng đợi: ${provider.currentIndex + 1}/${provider.playlist.length}',
              style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w700),
            ),
          ),
          const Icon(Icons.swipe_rounded, color: AppColors.mutedText, size: 18),
        ],
      ),
    );
  }
}
