import 'dart:async';
import 'package:just_audio/just_audio.dart';

class AudioEngine {
  // one player per pad id to allow overlapping and super-fast retrigger
  final Map<int, AudioPlayer> _players = {};

  Future<void> preload(int padId, String uri) async {
    final p = _players[padId] ?? AudioPlayer();
    _players[padId] = p;

    try {
      if (uri.startsWith('asset://')) {
        await p.setAsset(uri.replaceFirst('asset://', ''));
      } else {
        await p.setFilePath(uri);
      }
    } catch (e, st) {
      // don't let a single bad file crash the whole app. Log and rethrow so
      // callers can decide how to handle (we also catch higher up in the
      // controller). Provide helpful context about the uri.
      // On macOS this often means the app doesn't have permission to open
      // the file (e.g. protected folders). Surface a clear message in the
      // console for debugging.
      print('AudioEngine.preload: failed to load "$uri": $e');
      print(st);
      // rethrow so callers that want to handle can, but keep the error
      // informative. Many callers will catch and continue.
      rethrow;
    }
  }

  Future<void> play(
    int padId, {
    double volume = 1.0,
    bool loop = false,
    int fadeInMs = 10,
  }) async {
    final p = _players[padId];
    if (p == null) return;
    await p.setLoopMode(loop ? LoopMode.one : LoopMode.off);
    await p.setVolume(volume);
    // If the player is currently paused (not playing) and not completed, resume instead of restarting
    final ps = p.playerState;
    final isPlaying = ps.playing;
    final processing = ps.processingState;
    if (!isPlaying && processing != ProcessingState.completed) {
      // resume from current position
      await p.play();
      return;
    }

    // Otherwise restart from the beginning
    await p.seek(Duration.zero);
    // Approximate short fade-in by starting at low volume then ramping:
    if (fadeInMs > 0) {
      await p.setVolume(0.0);
      await p.play();
      // simple ramp (non-blocking). For production use a proper ramp/tween.
      Future.delayed(
        Duration(milliseconds: fadeInMs ~/ 2),
        () => p.setVolume(volume * 0.6),
      );
      Future.delayed(
        Duration(milliseconds: fadeInMs),
        () => p.setVolume(volume),
      );
    } else {
      await p.play();
    }
  }

  Future<void> stop(int padId, {int fadeOutMs = 20}) async {
    final p = _players[padId];
    if (p == null) return;
    if (fadeOutMs > 0) {
      final current = p.volume;
      await p.setVolume(current * 0.3);
      await Future.delayed(Duration(milliseconds: fadeOutMs ~/ 2));
      await p.setVolume(0.0);
    }
    await p.stop();
  }

  Future<void> stopAll() async {
    for (final p in _players.values) {
      await p.stop();
    }
  }

  Future<void> dispose() async {
    for (final p in _players.values) {
      await p.dispose();
    }
    _players.clear();
  }

  // Streams to surface playback state for UI (position, duration, playing)
  Stream<Duration> positionStream(int padId) {
    final p = _players[padId];
    return p?.positionStream ?? Stream<Duration>.value(Duration.zero);
  }

  Stream<Duration?> durationStream(int padId) {
    final p = _players[padId];
    return p?.durationStream ?? Stream<Duration?>.value(null);
  }

  Stream<bool> playingStream(int padId) {
    final p = _players[padId];
    return p?.playingStream ?? Stream<bool>.value(false);
  }
}
