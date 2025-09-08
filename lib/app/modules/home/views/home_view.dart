import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_pad/app/data/models/pad.dart';
import 'package:desktop_drop/desktop_drop.dart';
import '../../home/controllers/home_controller.dart';

import '../../../services/audio_service.dart';

class HomeView extends GetResponsiveView<HomeController> {
  HomeView({super.key});

  // Use separate responsive entry points (phone/tablet/desktop) instead of
  // a single build method. Each override delegates to _buildMain which
  // contains the original UI logic. We use Get.context to obtain a
  // BuildContext inside the overrides.

  @override
  Widget? phone() {
    final ctx = Get.context!;
    return _buildMain(ctx, preferTablet: false, preferDesktop: false);
  }

  @override
  Widget? tablet() {
    final ctx = Get.context!;
    return _buildMain(ctx, preferTablet: true, preferDesktop: false);
  }

  @override
  Widget? desktop() {
    final ctx = Get.context!;
    return _buildMain(ctx, preferTablet: true, preferDesktop: true);
  }

  // Shared implementation of the previous `build` body. The preferTablet
  // and preferDesktop flags allow the phone/tablet/desktop overrides to
  // influence layout while still respecting LayoutBuilder constraints.
  Widget _buildMain(
    BuildContext context, {
    required bool preferTablet,
    required bool preferDesktop,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: Obx(
          () => Text(
            controller.currentPalette.value?.name ?? 'Pro Pad',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        actions: [
          FilledButton.tonalIcon(
            onPressed: controller.stopAll,
            icon: const Icon(Icons.stop_circle_outlined, size: 20),
            label: const Text('Stop All'),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.errorContainer,
              foregroundColor: colorScheme.onErrorContainer,
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: controller.addPad,
            icon: const Icon(Icons.add, size: 20),
            label: const Text('Add Pad'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Obx(() {
        if (controller.isBusy.value) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'Loading audio files...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          );
        }

        final pal = controller.currentPalette.value;
        final pads = controller.pads;
        final padCount = pads.length;

        if (pal == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.music_note_outlined,
                  size: 64,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'No palette found',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your first palette to get started',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        final rows = pal.rows;
        final cols = pal.cols;
        final total = rows * cols;

        return LayoutBuilder(
          builder: (context, constraints) {
            // Responsive grid configuration
            final screenWidth = constraints.maxWidth;
            final isTablet = preferTablet || screenWidth > 600;
            final isDesktop = preferDesktop || screenWidth > 1200;

            // Adjust padding based on screen size
            final horizontalPadding = isDesktop
                ? 32.0
                : (isTablet ? 24.0 : 16.0);
            final verticalPadding = isDesktop ? 24.0 : (isTablet ? 20.0 : 16.0);

            // Adjust spacing based on screen size
            final padSpacing = isDesktop ? 16.0 : (isTablet ? 14.0 : 12.0);

            // Calculate optimal aspect ratio
            final aspectRatio = isDesktop
                ? Get.width / (Get.height * 0.5)
                : (isTablet ? 2.0 : 1.8);

            final grid = SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              crossAxisSpacing: padSpacing,
              mainAxisSpacing: padSpacing,
              childAspectRatio: aspectRatio,
            );

            return Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.surface,
                          colorScheme.surfaceVariant.withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: verticalPadding,
                      ),
                      child: DropTarget(
                        onDragDone: (details) async {
                          if (details.files.isNotEmpty) {
                            final fp = details.files.first.path;
                            await controller.handleGlobalDrop(fp);
                          }
                        },
                        child: GridView.builder(
                          itemCount: total,
                          gridDelegate: grid,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (index >= padCount) {
                              return _EmptyCell(
                                onTap: controller.addPad,
                                colorScheme: colorScheme,
                                theme: theme,
                              );
                            }

                            final pad = pads[index];

                            return _PadTile(
                              pad: pad,
                              controller: controller,
                              colorScheme: colorScheme,
                              theme: theme,
                              isDesktop: isDesktop,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                if (controller.pads.isNotEmpty)
                  SizedBox(
                    height: Get.height,
                    width: 30,
                    child: _MasterAudioMeter(controller: controller),
                  ),
              ],
            );
          },
        );
      }),
    );
  }
}

class _MasterAudioMeter extends StatefulWidget {
  final HomeController controller;
  const _MasterAudioMeter({required this.controller});

  @override
  State<_MasterAudioMeter> createState() => _MasterAudioMeterState();
}

class _MasterAudioMeterState extends State<_MasterAudioMeter> {
  final Map<int, StreamSubscription> _playingSubs = {};
  final Map<int, StreamSubscription> _levelSubs = {};
  final Map<int, bool> _isPlaying = {};
  final Map<int, (double, double)> _levels = {};
  final Map<int, String> _uris = {}; // track current uri per pad id
  final Set<int> _trackedPadIds = <int>{};
  (double, double) _combined = (0.0, 0.0);

  HomeController get _c => widget.controller;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  @override
  void didUpdateWidget(covariant _MasterAudioMeter oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Pads is an RxList whose identity doesn't change. Diff by IDs and URIs instead.
    _refreshBindings();
  }

  void _setup() {
    _refreshBindings();
  }

  void _teardown() {
    for (final s in _playingSubs.values) {
      s.cancel();
    }
    for (final s in _levelSubs.values) {
      s.cancel();
    }
    _playingSubs.clear();
    _levelSubs.clear();
    _isPlaying.clear();
    _levels.clear();
    _uris.clear();
    _trackedPadIds.clear();
    _combined = (0.0, 0.0);
  }

  void _bindPad(Pad pad) {
    _isPlaying[pad.id] = false;
    _levels[pad.id] = (0.0, 0.0);
    _uris[pad.id] = pad.uri;
    _trackedPadIds.add(pad.id);
    // Listen to playing state
    _playingSubs[pad.id]?.cancel();
    _playingSubs[pad.id] = _c.engine.playingStream(pad.id).listen((playing) {
      _isPlaying[pad.id] = playing;
      if (playing) {
        // When playback starts, (re)bind the level subscription to a fresh position stream
        _levelSubs[pad.id]?.cancel();
        final pos = _c.engine.positionStream(pad.id).asBroadcastStream();
        _levelSubs[pad.id] = _c.levels.levelsFor(_uris[pad.id]!, pos).listen((
          lr,
        ) {
          if (_isPlaying[pad.id] == true) {
            _levels[pad.id] = lr;
            _recompute();
          }
        });
      } else {
        // Stop tracking levels when not playing
        _levelSubs[pad.id]?.cancel();
        _levels[pad.id] = (0.0, 0.0);
        _recompute();
      }
    });
  }

  void _unbindPad(int id) {
    _playingSubs[id]?.cancel();
    _levelSubs[id]?.cancel();
    _playingSubs.remove(id);
    _levelSubs.remove(id);
    _isPlaying.remove(id);
    _levels.remove(id);
    _uris.remove(id);
    _trackedPadIds.remove(id);
  }

  void _refreshBindings() {
    final currentIds = _c.pads.map((p) => p.id).toSet();
    // Remove bindings for pads no longer present
    final toRemove = _trackedPadIds.difference(currentIds);
    for (final id in toRemove) {
      _unbindPad(id);
    }
    // Add bindings for new pads
    final toAdd = currentIds.difference(_trackedPadIds);
    for (final id in toAdd) {
      final pad = _c.pads.firstWhere(
        (p) => p.id == id,
        orElse: () => _c.pads.first,
      );
      _bindPad(pad);
    }
    // For existing pads, if URI changed (file replaced), update and, if playing, rebind level stream
    final intersection = currentIds.intersection(_trackedPadIds);
    for (final id in intersection) {
      final pad = _c.pads.firstWhere((p) => p.id == id);
      final oldUri = _uris[id];
      if (oldUri != pad.uri) {
        _uris[id] = pad.uri;
        if (_isPlaying[id] == true) {
          // rebind only the level subscription with new URI
          _levelSubs[id]?.cancel();
          final pos = _c.engine.positionStream(id).asBroadcastStream();
          _levelSubs[id] = _c.levels.levelsFor(pad.uri, pos).listen((lr) {
            if (_isPlaying[id] == true) {
              _levels[id] = lr;
              _recompute();
            }
          });
        }
      }
    }
  }

  void _recompute() {
    double l = 0.0, r = 0.0;
    _levels.forEach((id, lr) {
      if (_isPlaying[id] == true) {
        if (lr.$1 > l) l = lr.$1;
        if (lr.$2 > r) r = lr.$2;
      }
    });
    setState(() => _combined = (l, r));
  }

  @override
  void dispose() {
    _teardown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _LRBarsPainter(left: _combined.$1, right: _combined.$2),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _PadTile extends StatelessWidget {
  final Pad pad;
  final HomeController controller;
  final ColorScheme colorScheme;
  final ThemeData theme;
  final bool isDesktop;

  const _PadTile({
    required this.pad,
    required this.controller,
    required this.colorScheme,
    required this.theme,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: controller.engine.playingStream(pad.id),
      builder: (context, playingSnapshot) {
        final isPlaying = playingSnapshot.data == true;

        // determine whether the pad's audio was preloaded into the engine
        final loaded = controller.engine.isLoaded(pad.id);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: InkWell(
            onTap: () {
              if (isPlaying) {
                controller.stopPad(pad);
                return;
              }
              controller.resetPad(pad);
              controller.playPad(pad);
            },
            onSecondaryTap: () async {
              await _showEditPadMenu(context, pad, controller);
            },
            onDoubleTap: () => controller.resetPad(pad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isPlaying)
                  _PadProgress(
                    padId: pad.id,
                    engine: controller.engine,
                    decreasing: true,
                  ),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: !loaded
                              // not loaded -> greyed out pad
                              ? colorScheme.onSurface.withAlpha(30)
                              : (!isPlaying
                                    ? Color(pad.color)
                                    : colorScheme.surfaceContainerHighest),
                        ),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                width: isDesktop ? 100 : 80,
                                child: Text(
                                  pad.title,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: isDesktop ? 16 : 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // pad duration (use engine's duration stream)
                              StreamBuilder<Duration?>(
                                stream: controller.engine.durationStream(
                                  pad.id,
                                ),
                                builder: (context, durSnap) {
                                  final d = durSnap.data;
                                  String fmt(Duration dur) {
                                    final m = dur.inMinutes
                                        .remainder(60)
                                        .toString()
                                        .padLeft(2, '0');
                                    final s = dur.inSeconds
                                        .remainder(60)
                                        .toString()
                                        .padLeft(2, '0');
                                    return '$m:$s';
                                  }

                                  final txt = d != null ? fmt(d) : '';
                                  return Text(
                                    txt,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      // if (isPlaying)
                      //   Align(
                      //     alignment: Alignment.centerRight,
                      //     child: SizedBox(
                      //       width: 12,
                      //       child: _StereoAudioMeter(
                      //         pad: pad,
                      //         controller: controller,
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PadProgress extends StatelessWidget {
  final int padId;
  final AudioEngine engine;
  final bool decreasing;

  const _PadProgress({
    required this.padId,
    required this.engine,
    this.decreasing = false,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration?>(
      stream: engine.durationStream(padId),
      builder: (context, durSnap) {
        final dur = durSnap.data;
        return StreamBuilder<Duration>(
          stream: engine.positionStream(padId),
          builder: (context, posSnap) {
            final pos = posSnap.data ?? Duration.zero;
            double? value;
            if (dur != null && dur.inMilliseconds > 0) {
              value = pos.inMilliseconds / dur.inMilliseconds;
              if (value > 1.0) value = 1.0;
            }
            final display = (value != null && decreasing)
                ? (1.0 - value)
                : value;
            return LinearProgressIndicator(
              value: display,
              color: Colors.white.withAlpha(220),
              backgroundColor: Colors.white.withAlpha(40),
              minHeight: 8,
            );
          },
        );
      },
    );
  }
}

// _StereoAudioMeter widget removed (unused)

class _LRBarsPainter extends CustomPainter {
  final double left;
  final double right;
  _LRBarsPainter({required this.left, required this.right});

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = Colors.black.withOpacity(0.4);
    final radius = 6.0;
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    canvas.drawRRect(rect, bg);

    final barGap = 6.0;
    final barWidth = (size.width - barGap) / 2;
    final segHeight = 6.0;
    final segGap = 2.0;
    final maxSegs = (size.height / (segHeight + segGap)).floor();

    void drawBar(double x, double value) {
      final segmentsLit = (value * maxSegs).clamp(0, maxSegs).toInt();
      for (int i = 0; i < maxSegs; i++) {
        final topToBottomIndex = maxSegs - 1 - i;
        final y = topToBottomIndex * (segHeight + segGap) + segGap;
        final segRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, segHeight),
          const Radius.circular(2),
        );
        final active = i < segmentsLit;
        final t = i / (maxSegs - 1).clamp(1, maxSegs);
        final color = active
            ? Color.lerp(Colors.green, Colors.redAccent, t)!
            : Colors.white12;
        canvas.drawRRect(segRect, Paint()..color = color);
      }
    }

    drawBar(0, left);
    drawBar(barWidth + barGap, right);
  }

  @override
  bool shouldRepaint(covariant _LRBarsPainter oldDelegate) {
    return oldDelegate.left != left || oldDelegate.right != right;
  }
}

// Minimal, clean in-pad meter painter: two vertical bars with subtle tracks and solid fills.
// (Mini in-pad meter painter removed together with unused in-pad meter widget)

class _EmptyCell extends StatelessWidget {
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _EmptyCell({
    required this.onTap,
    required this.colorScheme,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.5),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 32,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              'Add Audio',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper: show edit pad menu dialog
Future<void> _showEditPadMenu(
  BuildContext context,
  Pad pad,
  HomeController controller,
) async {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  int selectedColor = pad.color;
  int fadeIn = pad.fadeInMs;
  int fadeOut = pad.fadeOutMs;
  bool loop = pad.loop;

  // local mutable copy of title for editing
  String title = pad.title;

  await showDialog<void>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text('Edit Pad'),
        content: StatefulBuilder(
          builder: (c, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: pad.title,
                    onChanged: (v) => title = v,
                    decoration: const InputDecoration(
                      hintText: 'Pad title',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Color', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final col in _presetColors)
                        GestureDetector(
                          onTap: () => setState(() => selectedColor = col),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Color(col),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedColor == col
                                    ? colorScheme.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Fade In (ms)', style: theme.textTheme.bodyMedium),
                  Slider(
                    min: 0,
                    max: 2000,
                    divisions: 20,
                    value: fadeIn.toDouble().clamp(0, 2000),
                    onChanged: (v) => setState(() => fadeIn = v.toInt()),
                  ),
                  Text('$fadeIn ms', style: theme.textTheme.bodySmall),
                  const SizedBox(height: 8),
                  Text('Fade Out (ms)', style: theme.textTheme.bodyMedium),
                  Slider(
                    min: 0,
                    max: 5000,
                    divisions: 20,
                    value: fadeOut.toDouble().clamp(0, 5000),
                    onChanged: (v) => setState(() => fadeOut = v.toInt()),
                  ),
                  Text('$fadeOut ms', style: theme.textTheme.bodySmall),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Loop', style: theme.textTheme.bodyMedium),
                      Switch(
                        value: loop,
                        onChanged: (val) => setState(() => loop = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Danger Zone',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.errorContainer,
                      foregroundColor: colorScheme.onErrorContainer,
                    ),
                    onPressed: () {
                      final navigator = Navigator.of(ctx);
                      showDialog<bool>(
                        context: ctx,
                        builder: (dctx) => AlertDialog(
                          title: const Text('Delete Pad?'),
                          content: const Text(
                            'This will permanently remove the pad.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(dctx).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(dctx).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      ).then((confirm) async {
                        if (confirm == true) {
                          navigator.pop();
                          await controller.deletePad(pad);
                        }
                      });
                    },
                    child: const Text('Delete Pad'),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final navigator = Navigator.of(ctx);
              final newTitle = title.trim();
              if (newTitle.isNotEmpty && newTitle != pad.title) {
                await controller.setPadTitle(pad, newTitle);
              }
              await controller.setPadColor(pad, selectedColor);
              await controller.setPadFadeInMs(pad, fadeIn);
              await controller.setPadFadeOutMs(pad, fadeOut);
              if (pad.loop != loop) await controller.togglePadLoop(pad);
              navigator.pop();
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

// Some nice preset swatches
const List<int> _presetColors = [
  0xFF3B82F6, // blue
  0xFF22C55E, // green
  0xFFF59E0B, // amber
  0xFFEF4444, // red
  0xFF8B5CF6, // purple
  0xFF06B6D4, // teal
];
