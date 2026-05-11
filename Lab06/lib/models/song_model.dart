import 'dart:typed_data';

import 'package:on_audio_query/on_audio_query.dart' as audio_query;

class SongModel {
  final String id;
  final String title;
  final String artist;
  final String? album;
  final String filePath;
  final Duration? duration;
  final String? albumArt;
  final int? fileSize;

  // Chi dung cho Flutter Web khi nguoi dung chon file tu trinh duyet.
  // Web khong cho app lay duong dan local that, nen can giu bytes de phat.
  final Uint8List? fileBytes;
  final String? mimeType;

  const SongModel({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    required this.filePath,
    this.duration,
    this.albumArt,
    this.fileSize,
    this.fileBytes,
    this.mimeType,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      album: json['album'] as String?,
      filePath: json['filePath'] as String,
      duration: json['duration'] == null
          ? null
          : Duration(milliseconds: json['duration'] as int),
      albumArt: json['albumArt'] as String?,
      fileSize: json['fileSize'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'filePath': filePath,
      'duration': duration?.inMilliseconds,
      'albumArt': albumArt,
      'fileSize': fileSize,
    };
  }

  factory SongModel.fromAudioQuery(audio_query.SongModel audio) {
    return SongModel(
      id: audio.id.toString(),
      title: audio.title,
      artist: audio.artist == null || audio.artist!.trim().isEmpty
          ? 'Unknown Artist'
          : audio.artist!,
      album: audio.album,
      filePath: audio.data,
      duration: Duration(milliseconds: audio.duration ?? 0),
      fileSize: audio.size,
    );
  }

  factory SongModel.fromPickedFile({
    required String name,
    String? path,
    int? size,
    Uint8List? bytes,
  }) {
    final cleanName = name.replaceAll(
      RegExp(r'\.(mp3|m4a|wav|flac|aac|ogg|mp4)$', caseSensitive: false),
      '',
    );
    final safeId = path ?? 'web_${DateTime.now().microsecondsSinceEpoch}_$name';

    return SongModel(
      id: safeId,
      title: cleanName.isEmpty ? 'Unknown Song' : cleanName,
      artist: 'Local File',
      album: 'Imported',
      filePath: path ?? name,
      fileSize: size,
      fileBytes: bytes,
      mimeType: _guessMimeType(name),
    );
  }

  static String _guessMimeType(String fileName) {
    final lowerName = fileName.toLowerCase();

    if (lowerName.endsWith('.mp3')) {
      return 'audio/mpeg';
    }
    if (lowerName.endsWith('.m4a')) {
      return 'audio/mp4';
    }
    if (lowerName.endsWith('.mp4')) {
      return 'video/mp4';
    }
    if (lowerName.endsWith('.wav')) {
      return 'audio/wav';
    }
    if (lowerName.endsWith('.flac')) {
      return 'audio/flac';
    }
    if (lowerName.endsWith('.aac')) {
      return 'audio/aac';
    }
    if (lowerName.endsWith('.ogg')) {
      return 'audio/ogg';
    }

    return 'audio/mpeg';
  }
}
