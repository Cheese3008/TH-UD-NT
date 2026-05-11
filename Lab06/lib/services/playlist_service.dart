import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart' as audio_query;

import '../models/song_model.dart';

class PlaylistService {
  final audio_query.OnAudioQuery _audioQuery = audio_query.OnAudioQuery();

  Future<List<SongModel>> getAllSongs() async {
    try {
      final List<audio_query.SongModel> audioList = await _audioQuery.querySongs(
        sortType: audio_query.SongSortType.TITLE,
        orderType: audio_query.OrderType.ASC_OR_SMALLER,
        uriType: audio_query.UriType.EXTERNAL,
        ignoreCase: true,
      );

      return audioList.map(SongModel.fromAudioQuery).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<SongModel>> pickAudioFiles() async {
    // Tren Web, browser khong cho lay duong dan file local that.
    // Vi vay can withData: true de lay bytes va phat bang data URI.
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: kIsWeb,
      type: FileType.custom,
      allowedExtensions: [
        'mp3',
        'm4a',
        'wav',
        'flac',
        'aac',
        'ogg',
        'mp4',
      ],
    );

    if (result == null) {
      return [];
    }

    return result.files
        .where((file) => file.path != null || file.bytes != null)
        .map((file) {
          return SongModel.fromPickedFile(
            path: file.path,
            name: file.name,
            size: file.size,
            bytes: file.bytes,
          );
        })
        .toList();
  }

  List<SongModel> searchSongs(List<SongModel> songs, String query) {
    final lowerQuery = query.trim().toLowerCase();
    if (lowerQuery.isEmpty) {
      return songs;
    }

    return songs.where((song) {
      return song.title.toLowerCase().contains(lowerQuery) ||
          song.artist.toLowerCase().contains(lowerQuery) ||
          (song.album?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }
}
