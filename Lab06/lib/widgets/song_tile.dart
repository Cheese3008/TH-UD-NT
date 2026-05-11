import 'package:flutter/material.dart';

import '../models/song_model.dart';
import '../utils/constants.dart';
import '../utils/duration_formatter.dart';
import 'album_art.dart';

class SongTile extends StatelessWidget {
  final SongModel song;
  final VoidCallback onTap;

  const SongTile({super.key, required this.song, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.88),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border.withOpacity(0.8)),
          ),
          child: Row(
            children: [
              AlbumArt(song: song, size: 58, borderRadius: 16),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _subtitle,
                      style: const TextStyle(color: AppColors.mutedText, fontSize: 12.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.cardSoft.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.more_horiz_rounded, color: AppColors.mutedText),
                  onPressed: () => _showOptionsMenu(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _subtitle {
    final duration = song.duration == null || song.duration == Duration.zero
        ? ''
        : ' • ${formatDuration(song.duration!)}';
    final album = song.album == null || song.album!.trim().isEmpty ? '' : ' • ${song.album}';
    return '${song.artist}$album$duration';
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                Row(
                  children: [
                    AlbumArt(song: song, size: 58),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song.title,
                            style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w800),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            song.artist,
                            style: const TextStyle(color: AppColors.mutedText),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.folder_rounded, color: AppColors.secondary),
                  title: const Text('Đường dẫn file', style: TextStyle(color: AppColors.text)),
                  subtitle: Text(song.filePath, maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
                ListTile(
                  leading: const Icon(Icons.close_rounded, color: AppColors.text),
                  title: const Text('Đóng', style: TextStyle(color: AppColors.text)),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
