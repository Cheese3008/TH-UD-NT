import 'package:flutter/material.dart';

import '../models/playlist_model.dart';
import '../utils/constants.dart';

class PlaylistCard extends StatelessWidget {
  final PlaylistModel playlist;
  final VoidCallback onTap;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  const PlaylistCard({
    super.key,
    required this.playlist,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.88),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: AppGradients.warm,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(Icons.queue_music_rounded, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlist.name,
                      style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w800, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${playlist.songIds.length} bài hát',
                      style: const TextStyle(color: AppColors.mutedText, fontSize: 13),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                color: AppColors.surface,
                icon: const Icon(Icons.more_horiz_rounded, color: AppColors.mutedText),
                onSelected: (value) {
                  if (value == 'rename') {
                    onRename();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'rename', child: Text('Đổi tên')),
                  PopupMenuItem(value: 'delete', child: Text('Xóa')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
