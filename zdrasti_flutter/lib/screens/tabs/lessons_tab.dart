import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/user.dart';
import 'package:zdrasti_flutter/models/lesson.dart';
import 'package:zdrasti_flutter/models/lesson_node.dart';
import 'package:zdrasti_flutter/backend/loader/lesson_loader.dart';
import 'package:zdrasti_flutter/backend/service/lesson_service.dart';
import 'package:zdrasti_flutter/backend/loader/lesson_map_loader.dart';
import '../../widgets/lessons/lessons_tab_map.dart';
import '../../widgets/lessons/lessons_tab_utils.dart';
import 'package:collection/collection.dart'; // needed for firstWhereOrNull

enum ScrollEdge { left, right }

class LessonsTab extends StatefulWidget {
  final User user;
  const LessonsTab({super.key, required this.user});

  @override
  State<LessonsTab> createState() => _LessonsTabState();
}

class _LessonsTabState extends State<LessonsTab> with TickerProviderStateMixin {
  List<LessonNode> _nodes = [];
  List<Lesson> _lessons = [];
  bool _loading = true;

  final PageController _pageController = PageController();
  final List<TransformationController> _transformControllers = [];
  final List<AnimationController> _glowControllers = [];
  final List<Animation<double>> _glowAnimations = [];
  final List<GlobalKey> _mapKeys = [];

  int _currentPage = 0;
  final Set<int> _scrolledPages = {};
  bool _isAutoScrolling = false;

  @override
  void initState() {
    super.initState();
    _loadLessonData();
  }

  Future<void> _loadLessonData() async {
    final lessons = await LessonLoader.loadLessonsForLevel(widget.user.current_level);
    final completed = await LessonService.getCompletedLessonIds(widget.user.id);
    final nodes = await LessonMapLoader.loadLessonNodes(
      level: widget.user.current_level,
      completedLessonIds: completed.toSet(),
    );

    final uniqueMaps = nodes.map((n) => n.mapId).toSet().toList();

    _transformControllers.clear();
    _glowControllers.clear();
    _glowAnimations.clear();
    _mapKeys.clear();

    for (int i = 0; i < uniqueMaps.length; i++) {
      _transformControllers.add(TransformationController());
      _mapKeys.add(GlobalKey());

      final glowController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      )..repeat(reverse: true);

      _glowControllers.add(glowController);
      _glowAnimations.add(Tween<double>(begin: 0.2, end: 0.6).animate(glowController));
    }

    setState(() {
      _lessons = lessons;
      _nodes = nodes;
      _loading = false;
    });
  }

  void _scrollWhenReady(int index) {
    setState(() => _isAutoScrolling = true);
    scrollWhenMapReady(
      mapKey: _mapKeys[index],
      controller: _transformControllers[index],
      vsync: this,
      onFinished: () {
        if (mounted) {
          setState(() => _isAutoScrolling = false);
        }
      },
    );
    _scrolledPages.add(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final c in _transformControllers) {
      c.dispose();
    }
    for (final c in _glowControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final mapIds = _nodes.map((n) => n.mapId).toSet().toList();

    // 🟣 Determine the globally active node
    final globalActiveNode = _nodes.firstWhereOrNull(
      (n) => n.status == LessonStatus.active,
    );

    final phasePages = List<Widget>.generate(mapIds.length, (index) {
      final mapId = mapIds[index];
      final controller = _transformControllers[index];
      final glowAnimation = _glowAnimations[index];
      final nodesForMap = _nodes.where((n) => n.mapId == mapId).toList();

      return LessonMapPage(
        key: ValueKey('map_$index'),
        mapKey: _mapKeys[index],
        nodesForMap: nodesForMap,
        allNodes: _nodes, // ✅ Pass full node list for global phase progress
        lessons: _lessons,
        glowAnimation: glowAnimation,
        transformController: controller,
        mapId: mapId,
        currentPageIndex: _currentPage,
        pageIndex: index,
        user: widget.user,
        isAutoScrolling: _isAutoScrolling,
        globalActiveNode: globalActiveNode,
        onGoPrevious: index > 0
            ? () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            : null,
        onGoNext: index < mapIds.length - 1
            ? () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            : null,
        onMapImageReady: () {
          if (_scrolledPages.contains(index)) return;
          _scrollWhenReady(index);
        },
      );
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: phasePages,
      ),
    );
  }
}
