import 'dart:async';
import 'dart:io';

import 'package:just_waveform/just_waveform.dart';

/// Lightweight audio level service that pre-extracts waveform peak data
/// per audio file and exposes a convenient lookup API to map a playback
/// position to an instantaneous L/R level in the range 0..1.
///
/// Notes
/// - just_waveform returns min/max peaks per pixel for the full mix (mono).
///   For common use, we approximate stereo by using the same value for L/R,
///   which still gives a satisfying visual meter that tracks loudness.
/// - Extraction is cached on disk next to the source file as a `.wave` file
///   and in-memory for fast access after the first run.
class AudioLevelService {
  final _waveforms = <String, Future<Waveform>>{}; // uri -> future waveform

  /// Extract (or load cached) waveform peaks for [audioPath].
  Future<Waveform> _getWaveform(String audioPath) async {
    // Return in-flight or cached
    final existing = _waveforms[audioPath];
    if (existing != null) return existing;

    final file = File(audioPath);
    final waveOut = File('${file.path}.wave');

    Future<Waveform> loadOrExtract() async {
      if (await waveOut.exists()) {
        return JustWaveform.parse(waveOut);
      }
      final stream = JustWaveform.extract(
        audioInFile: file,
        waveOutFile: waveOut,
        zoom: const WaveformZoom.pixelsPerSecond(80),
      );
      Waveform? wf;
      await for (final p in stream) {
        if (p.waveform != null) wf = p.waveform;
      }
      wf ??= Waveform(
        version: 2,
        flags: 0,
        sampleRate: 44100,
        samplesPerPixel: 100,
        length: 1,
        data: [0, 0],
      );
      return wf;
    }

    final fut = loadOrExtract();
    _waveforms[audioPath] = fut;
    return fut;
  }

  /// Convert the instantaneous peak for [audioPath] at [position] to a value
  /// in 0..1. Returns the same value for left and right (stereo approximation).
  Future<(double left, double right)> levelAt(
    String audioPath,
    Duration position,
  ) async {
    final wf = await _getWaveform(audioPath);
    final px = wf.positionToPixel(position).toInt();
    int min = 0, max = 0;
    if (px >= 0 && px < wf.length) {
      min = wf.getPixelMin(px);
      max = wf.getPixelMax(px);
    }
    // Normalize based on 16-bit range (-32768..32767)
    final peak = (max.abs() > min.abs() ? max.abs() : min.abs()).toDouble();
    final norm = (peak / 32767.0).clamp(0.0, 1.0);
    return (norm, norm);
  }

  /// Continuous stream of stereo levels for [audioPath] driven by
  /// the provided position stream. Efficiently reuses cached waveform.
  Stream<(double left, double right)> levelsFor(
    String audioPath,
    Stream<Duration> positionStream,
  ) {
    // Resolve waveform once and reuse for all positions.
    final wfFuture = _getWaveform(audioPath);
    const double epsilon = 0.02; // filter tiny changes to reduce repaints
    return positionStream
        // Map to pixel index and only proceed when pixel changes
        .asyncMap<int>((pos) async {
          try {
            final wf = await wfFuture;
            return wf.positionToPixel(pos).toInt();
          } catch (_) {
            return -1;
          }
        })
        .distinct()
        // Compute level for the pixel
        .asyncMap<(double, double)>((px) async {
          try {
            final wf = await wfFuture;
            int min = 0, max = 0;
            if (px >= 0 && px < wf.length) {
              min = wf.getPixelMin(px);
              max = wf.getPixelMax(px);
            }
            final peak = (max.abs() > min.abs() ? max.abs() : min.abs())
                .toDouble();
            final norm = (peak / 32767.0).clamp(0.0, 1.0);
            return (norm, norm);
          } catch (_) {
            return (0.0, 0.0);
          }
        })
        // Avoid emitting when differences are imperceptible
        .distinct(
          (a, b) =>
              (a.$1 - b.$1).abs() < epsilon && (a.$2 - b.$2).abs() < epsilon,
        );
  }
}
