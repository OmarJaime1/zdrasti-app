import 'package:flutter/material.dart';
import 'customization_item_tile.dart';

class CustomizationCategoryTab extends StatelessWidget {
  final String category;
  final List<String> items;
  final String selectedItemId;
  final List<String> unlockedItems;
  final void Function(String) onItemSelected;

  const CustomizationCategoryTab({
    required this.category,
    required this.items,
    required this.selectedItemId,
    required this.unlockedItems,
    required this.onItemSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final folder = category.toLowerCase();
    return GridView.count(
      crossAxisCount: 3,
      padding: const EdgeInsets.all(8),
      children: items.map((itemId) {
        return CustomizationItemTile(
          assetPath: 'assets/kuker_parts/$folder/$itemId.png',
          isLocked: !unlockedItems.contains(itemId),
          isSelected: selectedItemId == itemId,
          onTap: () => onItemSelected(itemId),
        );
      }).toList(),
    );
  }
}