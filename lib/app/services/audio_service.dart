import 'dart:async';
import 'package:just_audio/just_audio.dart';

class AudioEngine {
  // one player per pad id to allow overlapping and super-fast retrigger
  final Map<int, AudioPlayer> _players = {};

  Future<void> preload(int padId, String uri) async {
    // If we already have a player for this pad, reuse it and attempt to set
    // the source. If not, create a temporary player and only add it to the
    // active map after a successful load — that way callers can reliably
    // use `isLoaded` to check whether preload succeeded.
    final existing = _players[padId];
    if (existing != null) {
      try {
        if (uri.startsWith('asset://')) {
          await existing.setAsset(uri.replaceFirst('asset://', ''));
        } else {
          await existing.setFilePath(uri);
        }
        return;
      } catch (e, st) {
        print(
          'AudioEngine.preload: failed to load "${uri}" into existing player: $e',
        );
        print(st);
        rethrow;
      }
    }

    final p = AudioPlayer();
    try {
      if (uri.startsWith('asset://')) {
        await p.setAsset(uri.replaceFirst('asset://', ''));
      } else {
        await p.setFilePath(uri);
      }
      // Only add to the map once the player successfully loaded the source.
      _players[padId] = p;
    } catch (e, st) {
      // don't let a single bad file crash the whole app. Log and rethrow so
      // callers can decide how to handle (we also catch higher up in the
      // controller). Provide helpful context about the uri.
      print('AudioEngine.preload: failed to load "$uri": $e');
      print(st);
      // dispose the temporary player to avoid leaking resources
      try {
        await p.dispose();
      } catch (_) {}
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

  /// Returns true when a player has been created for [padId], i.e. the
  /// pad's audio was preloaded into the engine. The UI can use this to
  /// determine whether the pad is ready; if false, playback will fail until
  /// preload is performed.
  bool isLoaded(int padId) => _players.containsKey(padId);
}
