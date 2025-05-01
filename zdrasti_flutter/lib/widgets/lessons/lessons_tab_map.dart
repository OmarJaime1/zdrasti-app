import 'dart:async';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:zdrasti_flutter/backend/boss_loader.dart';
import 'package:zdrasti_flutter/models/kuker_boss.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/models/lesson_node.dart';
import 'package:zdrasti_flutter/models/user.dart';
import 'package:zdrasti_flutter/screens/boss/kuker_boss_screen.dart';
import 'package:zdrasti_flutter/widgets/boss/boss_icon.dart';
import 'lessons_tab_circles.dart';
import 'lessons_tab_utils.dart';
import 'phase_progress_bar.dart';

class LessonMapPage extends StatefulWidget {
  final List<LessonNode> nodesForMap;
  final List<LessonNode> allNodes;
  final List<Lesson> lessons;
  final Animation<double> glowAnimation;
  final TransformationController transformController;
  final String mapId;
  final int currentPageIndex;
  final int pageIndex;
  final User user;
  final VoidCallback? onGoNext;
  final VoidCallback? onGoPrevious;
  final GlobalKey mapKey;
  final VoidCallback? onMapImageReady;
  final bool isAutoScrolling;
  final LessonNode? globalActiveNode;

  const LessonMapPage({
    super.key,
    required this.nodesForMap,
    required this.allNodes,
    required this.lessons,
    required this.glowAnimation,
    required this.transformController,
    required this.mapId,
    required this.currentPageIndex,
    required this.pageIndex,
    required this.user,
    required this.mapKey,
    required this.isAutoScrolling,
    required this.globalActiveNode,
    this.onGoNext,
    this.onGoPrevious,
    this.onMapImageReady,
  });

  @override
  State<LessonMapPage> createState() => _LessonMapPageState();
}

class _LessonMapPageState extends State<LessonMapPage> with TickerProviderStateMixin {
  static const double mapWidth = 1536;
  static const double mapHeight = 1024;

  bool _showNextArrow = false;
  bool _showBackArrow = false;
  bool _imageReady = false;
  late List<AnimationController> _pulseControllers;
  late List<bool> _progressStates;
  final Set<int> _alreadyPulsedPhases = {};
  bool _isAnimatingPhase = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onMapScrolled());
    widget.transformController.addListener(_onMapScrolled);

    _pulseControllers = List.generate(3, (_) {
      final c = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      )..repeat(reverse: true);
      return c;
    });

    _progressStates = calculatePhaseCompletionStates(widget.allNodes);
    _maybeTriggerPulse(_progressStates);
  }

  @override
  void didUpdateWidget(covariant LessonMapPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newStates = calculatePhaseCompletionStates(widget.allNodes);
    if (!const ListEquality().equals(newStates, _progressStates)) {
      setState(() {
        _progressStates = newStates;
      });
      _maybeTriggerPulse(newStates);
    }
  }

  @override
  void dispose() {
    widget.transformController.removeListener(_onMapScrolled);
    for (final controller in _pulseControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onMapScrolled() {
    final matrix = widget.transformController.value;
    final x = matrix.getTranslation().x;
    final screenWidth = MediaQuery.of(context).size.width;

    final rightmostX = -(mapWidth - screenWidth);
    final atRight = (x - rightmostX).abs() < 60.0;
    final atLeft = x.abs() < 60.0;
    final isVisible = widget.pageIndex == widget.currentPageIndex;
    final showNext = isVisible && atRight && widget.onGoNext != null;
    final showBack = isVisible && atLeft && widget.onGoPrevious != null;

    if (_showNextArrow != showNext || _showBackArrow != showBack) {
      setState(() {
        _showNextArrow = showNext;
        _showBackArrow = showBack;
      });
    }
  }

  void _maybeTriggerPulse(List<bool> progressStates) {
    for (int i = 0; i < progressStates.length; i++) {
      if (progressStates[i] && !_alreadyPulsedPhases.contains(i)) {
        _pulseControllers[i].forward(from: 0.0);
        _alreadyPulsedPhases.add(i);

        Timer(const Duration(seconds: 5), () {
          if (mounted) _pulseControllers[i].reset();
        });

        if (widget.pageIndex == widget.currentPageIndex &&
            widget.onGoNext != null &&
            !_isAnimatingPhase &&
            i < 2) {
          _isAnimatingPhase = true;
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              _isAnimatingPhase = false;
              widget.onGoNext?.call();
            }
          });
        }
      }
    }
  }

  @override
Widget build(BuildContext context) {
  if (widget.nodesForMap.isEmpty) {
    return const Center(
      child: Text(
        'No lessons found for this map.',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  final background = widget.nodesForMap.first.background;
  final activePhaseIndex = _progressStates.indexWhere((p) => !p);
  final allComplete = _progressStates.every((p) => p);
  final noActive = widget.allNodes.every((n) => n.status == LessonStatus.completed);

  const bool forceShowBossIcon = true; // TEMP: dev testing
  final shouldShowBoss = (allComplete && noActive) || forceShowBossIcon;

  final lastAttempt = widget.user.last_writing_attempt;
  final cooldownActive = BossLoader.isWritingCooldownActive(lastAttempt);
  final cooldownRemaining = lastAttempt != null
      ? BossLoader.formatCooldownRemaining(lastAttempt)
      : '';

  final bossNode = widget.nodesForMap.firstWhereOrNull(
    (n) => n.lessonId == 'boss_a1',
  );

  return Stack(
    children: [
      InteractiveViewer(
        transformationController: widget.transformController,
        constrained: false,
        boundaryMargin: EdgeInsets.zero,
        minScale: 1,
        maxScale: 1,
        child: SizedBox(
          key: widget.mapKey,
          width: mapWidth,
          height: mapHeight,
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: AnimatedOpacity(
                  opacity: _imageReady ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Image.asset(
                    background,
                    fit: BoxFit.none,
                    alignment: Alignment.topLeft,
                    frameBuilder: (context, child, frame, _) {
                      if (frame != null && !_imageReady) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() => _imageReady = true);
                            widget.onMapImageReady?.call();
                          }
                        });
                      }
                      return child;
                    },
                  ),
                ),
              ),

              // Lesson Circles (skip boss)
              ...widget.nodesForMap.map((node) {
                if (node.lessonId == 'boss_a1') {
                  return const SizedBox.shrink();
                }

                final lesson = widget.lessons.firstWhereOrNull(
                  (l) => l.lessonId == node.lessonId,
                );
                if (lesson == null) {
                  return const SizedBox.shrink();
                }

                final isGlowing =
                    widget.globalActiveNode != null && node == widget.globalActiveNode;

                return Positioned(
                  left: node.position.dx,
                  top: node.position.dy,
                  child: LessonCircleButton(
                    node: node,
                    lesson: lesson,
                    isGlowing: isGlowing,
                    glowAnimation: widget.glowAnimation,
                    user: widget.user,
                  ),
                );
              }),

              // Boss Icon Widget
              if (shouldShowBoss && bossNode != null)
                
                FutureBuilder<KukerBoss>(
                  future: BossLoader.loadBossForLevel(widget.user.current_level),
                  builder: (context, snapshot) {
                    print('[DEBUG] Loading boss for level: ${widget.user.current_level}');
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }

                    final boss = snapshot.data!;

                    return Positioned(
                      left: bossNode.position.dx,
                      top: bossNode.position.dy,
                      child: BossIconWidget(
                        boss: boss,
                        defeated: false,
                        isCooldown: cooldownActive,
                        tooltipMessage: cooldownActive
                            ? "Boss is recovering... Available in $cooldownRemaining"
                            : "Challenge the ${boss.name}",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => KukerBossScreen(
                                boss: boss,
                                user: widget.user,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              else
                 Builder(builder: (_) {
                  return const SizedBox.shrink();
                }),
            ],
          ),
        ),
      ),

      if (_showBackArrow)
        Positioned(
          left: 0,
          top: 80,
          bottom: 80,
          child: GestureDetector(
            onTap: widget.onGoPrevious,
            child: Container(
              width: 48,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
          ),
        ),

      if (_showNextArrow)
        Positioned(
          right: 0,
          top: 80,
          bottom: 80,
          child: GestureDetector(
            onTap: widget.onGoNext,
            child: Container(
              width: 48,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
          ),
        ),

      if (widget.isAutoScrolling)
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(child: buildFloatingTooltip("Following path...")),
        ),

      PhaseProgressBar(
        phaseCompletion: _progressStates,
        activePhaseIndex: activePhaseIndex,
        pulseControllers: _pulseControllers,
      ),
    ],
  );
}

}