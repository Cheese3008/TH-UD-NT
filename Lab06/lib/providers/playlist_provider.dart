import 'package:flutter/material.dart';

import '../models/playlist_model.dart';
import '../services/storage_service.dart';

class PlaylistProvider extends ChangeNotifier {
  final StorageService _storageService;

  List<PlaylistModel> _playlists = [];
  bool _isLoaded = false;

  PlaylistProvider(this._storageService) {
    loadPlaylists();
  }

  List<PlaylistModel> get playlists => _playlists;
  bool get isLoaded => _isLoaded;

  Future<void> loadPlaylists() async {
    _playlists = await _storageService.getPlaylists();
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> createPlaylist(String name) async {
    final cleanName = name.trim();
    if (cleanName.isEmpty) {
      return;
    }

    final now = DateTime.now();
    final playlist = PlaylistModel(
      id: now.microsecondsSinceEpoch.toString(),
      name: cleanName,
      songIds: const [],
      createdAt: now,
      updatedAt: now,
    );

    _playlists = [..._playlists, playlist];
    await _save();
  }

  Future<void> renamePlaylist(String playlistId, String newName) async {
    final cleanName = newName.trim();
    if (cleanName.isEmpty) {
      return;
    }

    _playlists = _playlists.map((playlist) {
      if (playlist.id != playlistId) {
        return playlist;
      }
      return playlist.copyWith(name: cleanName);
    }).toList();

    await _save();
  }

  Future<void> deletePlaylist(String playlistId) async {
    _playlists = _playlists.where((playlist) => playlist.id != playlistId).toList();
    await _save();
  }

  Future<void> addSongToPlaylist(String playlistId, String songId) async {
    _playlists = _playlists.map((playlist) {
      if (playlist.id != playlistId) {
        return playlist;
      }

      if (playlist.songIds.contains(songId)) {
        return playlist;
      }

      return playlist.copyWith(songIds: [...playlist.songIds, songId]);
    }).toList();

    await _save();
  }

  Future<void> removeSongFromPlaylist(String playlistId, String songId) async {
    _playlists = _playlists.map((playlist) {
      if (playlist.id != playlistId) {
        return playlist;
      }

      return playlist.copyWith(
        songIds: playlist.songIds.where((id) => id != songId).toList(),
      );
    }).toList();

    await _save();
  }

  PlaylistModel? getPlaylistById(String playlistId) {
    for (final playlist in _playlists) {
      if (playlist.id == playlistId) {
        return playlist;
      }
    }
    return null;
  }

  Future<void> _save() async {
    await _storageService.savePlaylists(_playlists);
    notifyListeners();
  }
}
