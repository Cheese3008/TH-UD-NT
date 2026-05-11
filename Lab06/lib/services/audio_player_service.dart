import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../models/playback_state_model.dart';
import '../models/song_model.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<bool> get playingStream => _audioPlayer.playingStream;

  Duration get currentPosition => _audioPlayer.position;
  Duration? get currentDuration => _audioPlayer.duration;
  bool get isPlaying => _audioPlayer.playing;

  Stream<AppPlaybackState> get playbackStateStream {
    return Rx.combineLatest3<Duration, Duration?, bool, AppPlaybackState>(
      positionStream,
      durationStream,
      playingStream,
      (position, duration, isPlaying) {
        return AppPlaybackState(
          position: position,
          duration: duration ?? Duration.zero,
          isPlaying: isPlaying,
        );
      },
    );
  }

  Future<void> initSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  Future<void> loadAudio(SongModel song) async {
    try {
      if (song.fileBytes != null) {
        final dataUri = Uri.dataFromBytes(
          song.fileBytes!,
          mimeType: song.mimeType ?? 'audio/mpeg',
        );
        await _audioPlayer.setAudioSource(AudioSource.uri(dataUri));
        return;
      }

      await _audioPlayer.setFilePath(song.filePath);
    } catch (e) {
      throw Exception('Cannot load audio file: $e');
    }
  }

  Future<void> play() async {
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume.clamp(0.0, 1.0).toDouble());
  }

  Future<void> setSpeed(double speed) async {
    await _audioPlayer.setSpeed(speed.clamp(0.5, 2.0).toDouble());
  }

  Future<void> setLoopMode(LoopMode loopMode) async {
    await _audioPlayer.setLoopMode(loopMode);
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
