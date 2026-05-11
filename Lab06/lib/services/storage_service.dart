import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/playlist_model.dart';

class StorageService {
  static const String _playlistsKey = 'playlists';
  static const String _lastPlayedKey = 'last_played';
  static const String _shuffleKey = 'shuffle_enabled';
  static const String _repeatKey = 'repeat_mode';
  static const String _volumeKey = 'volume';

  Future<void> savePlaylists(List<PlaylistModel> playlists) async {
    final prefs = await SharedPreferences.getInstance();
    final playlistsJson = playlists.map((playlist) => playlist.toJson()).toList();
    await prefs.setString(_playlistsKey, jsonEncode(playlistsJson));
  }

  Future<List<PlaylistModel>> getPlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    final playlistsString = prefs.getString(_playlistsKey);

    if (playlistsString == null || playlistsString.isEmpty) {
      return [];
    }

    final List<dynamic> playlistsJson = jsonDecode(playlistsString) as List<dynamic>;
    return playlistsJson
        .map((json) => PlaylistModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveLastPlayed(String songId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastPlayedKey, songId);
  }

  Future<String?> getLastPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastPlayedKey);
  }

  Future<void> saveShuffleState(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_shuffleKey, enabled);
  }

  Future<bool> getShuffleState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_shuffleKey) ?? false;
  }

  Future<void> saveRepeatMode(int mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_repeatKey, mode);
  }

  Future<int> getRepeatMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_repeatKey) ?? 0;
  }

  Future<void> saveVolume(double volume) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_volumeKey, volume.clamp(0.0, 1.0).toDouble());
  }

  Future<double> getVolume() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_volumeKey) ?? 1.0;
  }
}
