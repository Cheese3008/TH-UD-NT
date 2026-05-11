import 'dart:io';

import 'package:flutter/material.dart';

import '../models/song_model.dart';
import '../utils/constants.dart';

class AlbumArt extends StatelessWidget {
  final SongModel song;
  final double size;
  final double borderRadius;

  const AlbumArt({
    super.key,
    required this.song,
    required this.size,
    this.borderRadius = 18,
  });

  @override
  Widget build(BuildContext context) {
    final hasArt = song.albumArt != null && File(song.albumArt!).existsSync();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: hasArt ? null : AppGradients.primary,
        color: hasArt ? AppColors.card : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.34),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: hasArt
          ? Image.file(File(song.albumArt!), fit: BoxFit.cover)
          : Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  right: -size * 0.12,
                  top: -size * 0.12,
                  child: Container(
                    width: size * 0.52,
                    height: size * 0.52,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.16),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Icon(Icons.music_note_rounded, size: size * 0.42, color: Colors.white),
              ],
            ),
    );
  }
}
