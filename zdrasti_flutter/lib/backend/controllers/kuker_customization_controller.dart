import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/backend/service/kuker_item_repository_service.dart';
import 'package:zdrasti_flutter/backend/service/kuker_repository_service.dart';
import 'package:zdrasti_flutter/models/kuker_data.dart';
import 'package:zdrasti_flutter/models/kuker_items.dart';

class KukerCustomizationController extends ChangeNotifier {
  final KukerRepository _kukerRepo = KukerRepository();
  final KukerItemRepository _itemRepo = KukerItemRepository();

  KukerData _currentKuker = KukerData.defaultKuker();
  KukerData get currentKuker => _currentKuker;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  List<String> _unlockedItems = [];
  List<String> get unlockedItems => _unlockedItems;

  Map<String, List<KukerItem>> _itemsByCategory = {};
  Map<String, List<KukerItem>> get itemsByCategory => _itemsByCategory;

  List<String> get categories => _itemsByCategory.keys.toList();

  Future<void> initialize() async {
    _isOnline = await KukerItemRepository.isOnline();

    final saved = await _kukerRepo.loadKuker();
    _unlockedItems = await _kukerRepo.getUnlockedItems();
    _itemsByCategory = await _itemRepo.loadGroupedByCategory();

    _currentKuker = saved ?? KukerData.defaultKuker();
    _isLoading = false;
    notifyListeners();
  }

  void updatePart(String category, String itemId) {
    _currentKuker = switch (category) {
      'Mask' => _currentKuker.copyWith(mask: itemId),
      'Horns' => _currentKuker.copyWith(horns: itemId),
      'Costume' => _currentKuker.copyWith(costume: itemId),
      'Accessory' => _currentKuker.copyWith(accessory: itemId),
      'Expression' => _currentKuker.copyWith(expression: itemId),
      'Shoes' => _currentKuker.copyWith(shoes: itemId),
      _ => _currentKuker,
    };
    notifyListeners();
  }

  void reset() {
    _currentKuker = KukerData.defaultKuker();
    notifyListeners();
  }

  Future<void> save() async {
    if (_isOnline) {
      await _kukerRepo.saveKuker(_currentKuker);
    }
  }
}