import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/audio_provider.dart';
import '../screens/now_playing_screen.dart';
import '../utils/constants.dart';
import 'album_art.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, provider, child) {
        final song = provider.currentSong;
        if (song == null) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NowPlayingScreen()),
              );
            },
            child: Container(
              height: AppSpacing.miniPlayerHeight,
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.96),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.border),
                boxShadow: AppShadows.soft,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Stack(
                  children: [
                    Positioned(
                      right: -40,
                      top: -40,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.16),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        StreamBuilder(
                          stream: provider.playbackStateStream,
                          builder: (context, snapshot) {
                            final progress = snapshot.data?.progress ?? 0.0;
                            return LinearProgressIndicator(
                              value: progress,
                              backgroundColor: AppColors.border,
                              color: AppColors.secondary,
                              minHeight: 3,
                            );
                          },
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                AlbumArt(song: song, size: 58, borderRadius: 18),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        song.title,
                                        style: const TextStyle(
                                          color: AppColors.text,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        song.artist,
                                        style: const TextStyle(color: AppColors.mutedText, fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                StreamBuilder<bool>(
                                  stream: provider.playingStream,
                                  builder: (context, snapshot) {
                                    final isPlaying = snapshot.data ?? false;
                                    return Container(
                                      width: 44,
                                      height: 44,
                                      decoration: const BoxDecoration(
                                        gradient: AppGradients.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                        onPressed: provider.playPause,
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.skip_next_rounded, color: AppColors.text),
                                  onPressed: provider.next,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
