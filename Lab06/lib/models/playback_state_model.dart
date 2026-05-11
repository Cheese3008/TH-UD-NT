class AppPlaybackState {
  final Duration position;
  final Duration duration;
  final bool isPlaying;

  const AppPlaybackState({
    required this.position,
    required this.duration,
    required this.isPlaying,
  });

  double get progress {
    if (duration.inMilliseconds <= 0) {
      return 0;
    }

    final value = position.inMilliseconds / duration.inMilliseconds;
    return value.clamp(0.0, 1.0).toDouble();
  }
}
