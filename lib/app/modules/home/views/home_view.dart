import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_pad/app/data/models/pad.dart';
import 'package:desktop_drop/desktop_drop.dart';
import '../../home/controllers/home_controller.dart';

import '../../../services/audio_service.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
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
          return Center(
            child: Column(
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
            ),
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
            final isTablet = screenWidth > 600;
            final isDesktop = screenWidth > 1200;

            // Adjust padding based on screen size
            final horizontalPadding = isDesktop
                ? 32.0
                : (isTablet ? 24.0 : 16.0);
            final verticalPadding = isDesktop ? 24.0 : (isTablet ? 20.0 : 16.0);

            // Adjust spacing based on screen size
            final padSpacing = isDesktop ? 16.0 : (isTablet ? 14.0 : 12.0);

            // Calculate optimal aspect ratio
            final aspectRatio = isDesktop ? 2.2 : (isTablet ? 2.0 : 1.8);

            final grid = SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              crossAxisSpacing: padSpacing,
              mainAxisSpacing: padSpacing,
              childAspectRatio: aspectRatio,
            );

            return Container(
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
            );
          },
        );
      }),
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

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Material(
            elevation: isPlaying ? 12 : 4,
            borderRadius: BorderRadius.circular(20),
            shadowColor: Color(pad.color).withOpacity(0.4),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => controller.playPad(pad),
              onDoubleTap: () => controller.resetPad(pad),
              onLongPress: () => controller.stopPad(pad),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(pad.color),
                      Color(pad.color).withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: isPlaying
                      ? Border.all(
                          color: Colors.white.withOpacity(0.6),
                          width: 2,
                        )
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Animated background pattern for playing state
                      if (isPlaying)
                        Positioned.fill(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.1),
                                  Colors.transparent,
                                  Colors.white.withOpacity(0.05),
                                ],
                              ),
                            ),
                          ),
                        ),

                      // Progress indicator at top
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _PadProgress(
                            padId: pad.id,
                            engine: controller.engine,
                            decreasing: true,
                          ),
                        ),
                      ),

                      // Main content area
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            16,
                            isDesktop ? 28 : 24,
                            16,
                            12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title section
                              Expanded(
                                child: Center(
                                  child: Text(
                                    pad.title,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: isDesktop ? 16 : 14,
                                          shadows: [
                                            Shadow(
                                              offset: const Offset(0, 1),
                                              blurRadius: 2,
                                              color: Colors.black.withOpacity(
                                                0.3,
                                              ),
                                            ),
                                          ],
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),

                              // Bottom section with controls
                              Row(
                                children: [
                                  // Audio level indicator
                                  SizedBox(
                                    width: 6,
                                    height: 28,
                                    child: _AudioMeter(
                                      padId: pad.id,
                                      engine: controller.engine,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Loop indicator
                                  if (pad.loop)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.repeat,
                                        size: 12,
                                        color: Color(pad.color),
                                      ),
                                    ),

                                  const Spacer(),

                                  // Volume indicator
                                  if (pad.volume < 1.0)
                                    Icon(
                                      Icons.volume_down,
                                      size: 16,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Playing pulse effect
                      if (isPlaying)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
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
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: display,
                color: Colors.white.withOpacity(0.9),
                backgroundColor: Colors.white.withOpacity(0.2),
                minHeight: 8,
              ),
            );
          },
        );
      },
    );
  }
}

class _AudioMeter extends StatelessWidget {
  final int padId;
  final AudioEngine engine;

  const _AudioMeter({required this.padId, required this.engine});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: engine.playingStream(padId),
      builder: (context, snap) {
        final playing = snap.data == true;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: playing
                  ? [
                      Colors.green.shade400,
                      Colors.green.shade300,
                      Colors.white.withOpacity(0.9),
                    ]
                  : [
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.2),
                    ],
            ),
          ),
          child: FractionallySizedBox(
            heightFactor: playing ? 1.0 : 0.2,
            alignment: Alignment.bottomCenter,
          ),
        );
      },
    );
  }
}

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
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(20),
      color: colorScheme.surfaceVariant,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
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
      ),
    );
  }
}
