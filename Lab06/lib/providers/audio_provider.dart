import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../models/playback_state_model.dart';
import '../models/song_model.dart';
import '../services/audio_player_service.dart';
import '../services/storage_service.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayerService _audioService;
  final StorageService _storageService;

  final Random _random = Random();

  List<SongModel> _playlist = [];
  int _currentIndex = 0;
  bool _isShuffleEnabled = false;
  LoopMode _loopMode = LoopMode.off;
  double _volume = 1.0;

  AudioProvider(this._audioService, this._storageService) {
    _init();
    _audioService.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _handleSongCompleted();
      }
    });
  }

  List<SongModel> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  SongModel? get currentSong => _playlist.isEmpty ? null : _playlist[_currentIndex];
  bool get isShuffleEnabled => _isShuffleEnabled;
  LoopMode get loopMode => _loopMode;
  double get volume => _volume;

  Stream<Duration> get positionStream => _audioService.positionStream;
  Stream<Duration?> get durationStream => _audioService.durationStream;
  Stream<bool> get playingStream => _audioService.playingStream;
  Stream<AppPlaybackState> get playbackStateStream => _audioService.playbackStateStream;

  Future<void> _init() async {
    await _audioService.initSession();
    _isShuffleEnabled = await _storageService.getShuffleState();

    final repeatMode = await _storageService.getRepeatMode();
    if (repeatMode >= 0 && repeatMode < LoopMode.values.length) {
      _loopMode = LoopMode.values[repeatMode];
    }

    _volume = await _storageService.getVolume();
    await _audioService.setVolume(_volume);
    await _audioService.setLoopMode(_loopMode == LoopMode.one ? LoopMode.one : LoopMode.off);
    notifyListeners();
  }

  Future<void> setPlaylist(List<SongModel> songs, int startIndex) async {
    if (songs.isEmpty) {
      return;
    }

    _playlist = songs;
    _currentIndex = startIndex.clamp(0, songs.length - 1).toInt();
    await _playSongAtIndex(_currentIndex);
  }

  Future<void> _playSongAtIndex(int index) async {
    if (_playlist.isEmpty || index < 0 || index >= _playlist.length) {
      return;
    }

    _currentIndex = index;
    final song = _playlist[index];

    await _audioService.loadAudio(song);
    await _audioService.play();
    await _storageService.saveLastPlayed(song.id);
    notifyListeners();
  }

  Future<void> playPause() async {
    if (_audioService.isPlaying) {
      await _audioService.pause();
    } else {
      await _audioService.play();
    }
    notifyListeners();
  }

  Future<void> next() async {
    if (_playlist.isEmpty) {
      return;
    }

    if (_isShuffleEnabled) {
      _currentIndex = _getRandomIndex();
    } else {
      _currentIndex = (_currentIndex + 1) % _playlist.length;
    }

    await _playSongAtIndex(_currentIndex);
  }

  Future<void> previous() async {
    if (_playlist.isEmpty) {
      return;
    }

    if (_audioService.currentPosition.inSeconds > 3) {
      await _audioService.seek(Duration.zero);
      return;
    }

    if (_isShuffleEnabled) {
      _currentIndex = _getRandomIndex();
    } else {
      _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    }

    await _playSongAtIndex(_currentIndex);
  }

  Future<void> seek(Duration position) async {
    await _audioService.seek(position);
  }

  Future<void> toggleShuffle() async {
    _isShuffleEnabled = !_isShuffleEnabled;
    await _storageService.saveShuffleState(_isShuffleEnabled);
    notifyListeners();
  }

  Future<void> toggleRepeat() async {
    switch (_loopMode) {
      case LoopMode.off:
        _loopMode = LoopMode.all;
        break;
      case LoopMode.all:
        _loopMode = LoopMode.one;
        break;
      case LoopMode.one:
        _loopMode = LoopMode.off;
        break;
    }

    await _audioService.setLoopMode(_loopMode == LoopMode.one ? LoopMode.one : LoopMode.off);
    await _storageService.saveRepeatMode(_loopMode.index);
    notifyListeners();
  }

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0).toDouble();
    await _audioService.setVolume(_volume);
    await _storageService.saveVolume(_volume);
    notifyListeners();
  }

  int _getRandomIndex() {
    if (_playlist.length <= 1) {
      return 0;
    }

    int nextIndex = _random.nextInt(_playlist.length);
    while (nextIndex == _currentIndex) {
      nextIndex = _random.nextInt(_playlist.length);
    }
    return nextIndex;
  }

  Future<void> _handleSongCompleted() async {
    if (_playlist.isEmpty || _loopMode == LoopMode.one) {
      return;
    }

    if (_loopMode == LoopMode.off && _currentIndex == _playlist.length - 1) {
      await _audioService.stop();
      return;
    }

    await next();
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
