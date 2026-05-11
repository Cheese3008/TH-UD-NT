import 'package:flutter_test/flutter_test.dart';
import 'package:offline_music_player/utils/duration_formatter.dart';

void main() {
  test('formatDuration returns mm:ss', () {
    expect(formatDuration(const Duration(seconds: 65)), '01:05');
    expect(formatDuration(const Duration(minutes: 3, seconds: 7)), '03:07');
  });
}
