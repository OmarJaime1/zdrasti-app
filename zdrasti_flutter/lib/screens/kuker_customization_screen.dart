import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/backend/service/kuker_item_repository_service.dart';
import 'package:zdrasti_flutter/backend/service/kuker_repository_service.dart';
import 'package:zdrasti_flutter/models/kuker_items.dart';
import 'package:zdrasti_flutter/widgets/customize_kuker/customization_category_tab.dart';
import '../models/kuker_data.dart';
import '../widgets/customize_kuker/static_kuker_renderer.dart';

class KukerCustomizationScreen extends StatefulWidget {
  const KukerCustomizationScreen({super.key});

  @override
  State<KukerCustomizationScreen> createState() => _KukerCustomizationScreenState();
}

class _KukerCustomizationScreenState extends State<KukerCustomizationScreen> with TickerProviderStateMixin {
  late KukerData _currentKuker;
  late TabController _tabController;
  late KukerRepository _kukerRepo;
  List<String> _unlockedItems = [];
  bool _isLoading = true;
  bool _isOnline = true;
  late final KukerItemRepository _itemRepo;
  Map<String, List<KukerItem>> _itemsByCategory = {};
  List<String> get categories => _itemsByCategory.keys.toList();

  @override
  void initState() {
    super.initState();
    _kukerRepo = KukerRepository();
    _itemRepo = KukerItemRepository();
    _loadKukerData();
    _checkOnlineStatus();
  }

  Future<void> _loadKukerData() async {
    final saved = await _kukerRepo.loadKuker();
    final unlocked = await _kukerRepo.getUnlockedItems();
    _itemsByCategory = await _itemRepo.loadGroupedByCategory();

    setState(() {
      _currentKuker = saved ?? KukerData.defaultKuker();
      _unlockedItems = unlocked;
      _isLoading = false;
    });
  }

  Future<void> _checkOnlineStatus() async {
    final isOnline = await KukerItemRepository.isOnline();
    setState(() {
      _isOnline = isOnline;
    });
  }


  void _updateKuker(String category, String itemId) {
    setState(() {
      switch (category) {
        case 'Mask':
          _currentKuker = _currentKuker.copyWith(mask: itemId);
          break;
        case 'Horns':
          _currentKuker = _currentKuker.copyWith(horns: itemId);
          break;
        case 'Costume':
          _currentKuker = _currentKuker.copyWith(costume: itemId);
          break;
        case 'Accessory':
          _currentKuker = _currentKuker.copyWith(accessory: itemId);
          break;
        case 'Expression':
          _currentKuker = _currentKuker.copyWith(expression: itemId);
          break;
        case 'Shoes':
          _currentKuker = _currentKuker.copyWith(shoes: itemId);
          break;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customize Your Kuker')),
      body: _isLoading
      ? const Center(child: CircularProgressIndicator())
      : Column(
          children: [
            if (!_isOnline)
              Container(
                width: double.infinity,
                color: Colors.red.withOpacity(0.85),
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'Offline – Customization changes will not be saved',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 12),
            StaticKukerRenderer(kuker: _currentKuker),
            const SizedBox(height: 8),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: categories.map((c) => Tab(text: c)).toList(),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: categories.map((category) {
                  final items = _itemsByCategory[category] ?? [];
                  final selected = _currentKuker.toMap()[category.toLowerCase()]!;
                  return CustomizationCategoryTab(
                    category: category,
                    items: items.map((item) => item.id).toList(),
                    selectedItemId: selected,
                    unlockedItems: _unlockedItems,
                    onItemSelected: (itemId) => _updateKuker(category, itemId),
                  );
                }).toList(),
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => setState(() => _currentKuker = KukerData.defaultKuker()),
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: _isOnline
                      ? () async {
                          await _kukerRepo.saveKuker(_currentKuker);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Kuker saved!')),
                          );
                        }
                      : null,
                  child: const Text('Save Kuker'),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
    );
  }
}