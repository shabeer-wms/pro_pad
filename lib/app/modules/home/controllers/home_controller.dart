import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pro_pad/app/repositories/palette_repository.dart';
import '../../../data/models/palette.dart';
import '../../../data/models/pad.dart';
import '../../../services/audio_service.dart';
import '../../../services/audio_level_service.dart';

class HomeController extends GetxController {
  final repo = PaletteRepository();
  final engine = AudioEngine();
  final levels = AudioLevelService();

  final Rx<Palette?> currentPalette = Rx<Palette?>(null);
  final pads = <Pad>[].obs;
  final isBusy = false.obs;
  // track which pad ids are currently being hovered by a drag operation
  final hoveredPadIds = <int>{}.obs;
  // pad id to show in the right-side audio meter (null = none)
  final Rxn<int> activeMeterPadId = Rxn<int>();

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadInitial();
  }

  Future<void> _loadInitial() async {
    isBusy.value = true;
    final pal = await repo.getFirstPalette();
    if (pal != null) {
      await pal.pads.load();
      currentPalette.value = pal;
      pads.assignAll(pal.pads.toList());
      // Preload all pad audio. Individual preload failures shouldn't crash
      // the whole app (eg. permission errors on macOS). Log and continue.
      for (final pad in pads) {
        try {
          await engine.preload(pad.id, pad.uri);
          // Warm the waveform cache in the background (non-fatal)
          // Optionally warm waveform cache lazily when position stream starts.
        } catch (e) {
          // Keep going; the UI will show the pad but playback will fail until
          // the user fixes the file or reassigns it.
          debugPrint(
            'HomeController._loadInitial: failed to preload pad ${pad.id} (${pad.uri}): $e',
          );
        }
      }
    }
    isBusy.value = false;
  }

  Future<void> addPad() async {
    final pick = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav', 'mp3', 'aac', 'm4a', 'ogg'],
    );
    if (pick == null || pick.files.single.path == null) return;

    final file = File(pick.files.single.path!);
    // copy into app support so the app keeps access to the file across
    // launches and avoids macOS permission restrictions.
    final destPath = await _copyIntoAppSupport(file);
    final p = Pad()
      ..title = pick.files.single.name
      ..uri = destPath
      ..color = 0xFF22C55E; // green
    // additional defaults left as-is

    final pal = currentPalette.value;
    if (pal == null) return;

    // persist the pad
    await repo.addPadToPalette(pal, p);

    // update the local observable list immediately so the UI reacts
    pads.add(p);

    // reload persisted pads to keep the local list in sync
    await pal.pads.load();
    pads.assignAll(pal.pads.toList());

    // preload audio into the engine (non-fatal)
    try {
      await engine.preload(p.id, p.uri);
      // Optionally warm waveform cache lazily when position stream starts.
      // Ensure observable list refresh so the view notices the loaded state
      final idx = pads.indexWhere((x) => x.id == p.id);
      if (idx != -1) pads[idx] = pads[idx];
    } catch (e) {
      debugPrint('HomeController.addPad: preload failed for pad ${p.id}: $e');
    }
  }

  /// Copy the given [file] into the application's support directory and
  /// return the new absolute path. If copy fails, returns the original path.
  Future<String> _copyIntoAppSupport(File file) async {
    try {
      final appDir = await getApplicationSupportDirectory();
      final padsDir = Directory('${appDir.path}/pads');
      if (!padsDir.existsSync()) {
        padsDir.createSync(recursive: true);
      }
      final dest = File('${padsDir.path}/${file.uri.pathSegments.last}');
      // If file already exists, create a unique name to avoid overwriting
      if (dest.existsSync()) {
        final stamp = DateTime.now().millisecondsSinceEpoch;
        final name = file.uri.pathSegments.last;
        final parts = name.split('.');
        final newName = parts.length > 1
            ? '${parts.sublist(0, parts.length - 1).join('.')}_$stamp.${parts.last}'
            : '${name}_$stamp';
        final unique = File('${padsDir.path}/$newName');
        await file.copy(unique.path);
        return unique.path;
      }
      await file.copy(dest.path);
      return dest.path;
    } catch (e) {
      debugPrint(
        'HomeController._copyIntoAppSupport failed for ${file.path}: $e',
      );
      return file.path;
    }
  }

  Future<void> playPad(Pad pad) async {
    try {
      // mark this pad as active for the audio meter
      activeMeterPadId.value = pad.id;

      // If loop is enabled, play() will not complete naturally.
      if (pad.loop) {
        await engine.play(
          pad.id,
          volume: pad.volume,
          loop: pad.loop,
          fadeInMs: pad.fadeInMs,
        );
        return;
      }

      // For non-looping pads, this Future completes when playback finishes.
      await engine.play(
        pad.id,
        volume: pad.volume,
        loop: pad.loop,
        fadeInMs: pad.fadeInMs,
      );
      debugPrint('HomeController.playPad: pad ${pad.id} completed');
      await engine.stop(pad.id);
      // clear active meter after non-looping pad finishes
      if (activeMeterPadId.value == pad.id) activeMeterPadId.value = null;
    } catch (e) {
      debugPrint('HomeController.playPad: failed for pad ${pad.id}: $e');
      // clear active on failure
      if (activeMeterPadId.value == pad.id) activeMeterPadId.value = null;
    }
  }

  /// Handle a file dropped onto an existing pad: update pad uri/title, persist, and preload.
  Future<void> dropFileOnPad(Pad pad, String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) return;

    pad.uri = file.path;
    pad.title = file.uri.pathSegments.isNotEmpty
        ? file.uri.pathSegments.last
        : file.path;

    // persist the updated pad
    await repo.updatePad(pad);

    // update local observable list item so UI shows new title/color etc immediately
    final idx = pads.indexWhere((p) => p.id == pad.id);
    if (idx != -1) {
      pads[idx] = pad;
    }

    // preload the new audio file into the engine
    try {
      await engine.preload(pad.id, pad.uri);
      // Optionally warm waveform cache lazily when position stream starts.
      final i = pads.indexWhere((x) => x.id == pad.id);
      if (i != -1) pads[i] = pads[i];
    } catch (e) {
      debugPrint(
        'HomeController.dropFileOnPad: preload failed for ${pad.id}: $e',
      );
    }

    // clear hover state for this pad if present
    hoveredPadIds.remove(pad.id);
  }

  /// mark/unmark a pad id as hovered (called from the view drag events)
  void setPadHover(int padId, bool hovering) {
    if (hovering) {
      hoveredPadIds.add(padId);
    } else {
      hoveredPadIds.remove(padId);
    }
  }

  /// Handle a file dropped anywhere on the grid: auto-add to first empty cell or replace the first pad.
  Future<void> handleGlobalDrop(String filePath) async {
    final pal = currentPalette.value;
    if (pal == null) return;

    final total = pal.rows * pal.cols;

    // if space available, create a new pad and add it
    if (pads.length < total) {
      final file = File(filePath);
      if (!file.existsSync()) return;

      final p = Pad()
        ..title = file.uri.pathSegments.isNotEmpty
            ? file.uri.pathSegments.last
            : file.path
        ..uri = file.path
        ..color = 0xFF22C55E;

      await repo.addPadToPalette(pal, p);

      // refresh local pads from persisted palette
      await pal.pads.load();
      pads.assignAll(pal.pads.toList());

      try {
        await engine.preload(p.id, p.uri);
        // ensure observable refresh so the UI shows the pad as playable
        final idx = pads.indexWhere((x) => x.id == p.id);
        if (idx != -1) pads[idx] = pads[idx];
      } catch (e) {
        debugPrint(
          'HomeController.handleGlobalDrop: preload failed for pad ${p.id}: $e',
        );
      }
      return;
    }

    // otherwise replace the first pad (simple policy) and persist
    final first = pads.first;
    final file = File(filePath);
    if (!file.existsSync()) return;

    first.uri = file.path;
    first.title = file.uri.pathSegments.isNotEmpty
        ? file.uri.pathSegments.last
        : file.path;
    await repo.updatePad(first);

    // update observable list so UI refreshes
    pads[0] = first;

    try {
      await engine.preload(first.id, first.uri);
      // Optionally warm waveform cache lazily when position stream starts.
      final idx = pads.indexWhere((x) => x.id == first.id);
      if (idx != -1) pads[idx] = pads[idx];
    } catch (e) {
      debugPrint(
        'HomeController.handleGlobalDrop: preload failed for replaced pad ${first.id}: $e',
      );
    }
  }

  Future<void> stopPad(Pad pad) async {
    await engine.stop(pad.id, fadeOutMs: pad.fadeOutMs);
    if (activeMeterPadId.value == pad.id) activeMeterPadId.value = null;
  }

  Future<void> stopAll() => engine.stopAll();

  @override
  void onClose() {
    engine.dispose();
    super.onClose();
  }

  void resetPad(Pad pad) async {
    await engine.preload(pad.id, pad.uri);
  }

  /// Update pad color and persist.
  Future<void> setPadColor(Pad pad, int color) async {
    pad.color = color;
    await repo.updatePad(pad);
    final idx = pads.indexWhere((p) => p.id == pad.id);
    if (idx != -1) pads[idx] = pads[idx];
  }

  /// Update pad fade-in milliseconds and persist.
  Future<void> setPadFadeInMs(Pad pad, int ms) async {
    pad.fadeInMs = ms;
    await repo.updatePad(pad);
    final idx = pads.indexWhere((p) => p.id == pad.id);
    if (idx != -1) pads[idx] = pads[idx];
  }

  /// Update pad fade-out milliseconds and persist.
  Future<void> setPadFadeOutMs(Pad pad, int ms) async {
    pad.fadeOutMs = ms;
    await repo.updatePad(pad);
    final idx = pads.indexWhere((p) => p.id == pad.id);
    if (idx != -1) pads[idx] = pads[idx];
  }

  /// Toggle pad loop flag and persist.
  Future<void> togglePadLoop(Pad pad) async {
    pad.loop = !pad.loop;
    await repo.updatePad(pad);
    final idx = pads.indexWhere((p) => p.id == pad.id);
    if (idx != -1) pads[idx] = pads[idx];
  }

  /// Delete a pad from the current palette and persist removal.
  Future<void> deletePad(Pad pad) async {
    final pal = currentPalette.value;
    if (pal == null) return;
    try {
      await repo.removePad(pal, pad);
      pads.removeWhere((p) => p.id == pad.id);
    } catch (e) {
      debugPrint(
        'HomeController.deletePad: failed to delete pad ${pad.id}: $e',
      );
    }
    // ensure engine stops and resources are cleaned up for this pad id
    try {
      await engine.stop(pad.id);
    } catch (_) {}
    if (activeMeterPadId.value == pad.id) activeMeterPadId.value = null;
  }

  Future<void> handleDropAt(int padCount, String fp) async {
    debugPrint('handleDropAt: padCount=$padCount, fp=$fp');
  }

  Future<void> setPadTitle(Pad pad, String newTitle) async {
    pad.title = newTitle;
    await repo.updatePad(pad);
    final idx = pads.indexWhere((p) => p.id == pad.id);
    if (idx != -1) pads[idx] = pads[idx];
  }
}
