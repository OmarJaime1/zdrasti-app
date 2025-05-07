import 'package:flutter/material.dart';

class CustomizationItemTile extends StatelessWidget {
  final String assetPath;
  final bool isLocked;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomizationItemTile({
    required this.assetPath,
    required this.onTap,
    this.isLocked = false,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(6),
            decoration: _decoration(isSelected),
            child: ColorFiltered(
              colorFilter: _filterForLocked(isLocked),
              child: Image.asset(assetPath, height: 60),
            ),
          ),
          if (isLocked)
            const Positioned.fill(
              child: Icon(Icons.lock, color: Colors.white70, size: 30),
            ),
        ],
      ),
    );
  }

  ColorFilter _filterForLocked(bool locked) {
    return locked
        ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
        : const ColorFilter.mode(Colors.transparent, BlendMode.multiply);
  }

  BoxDecoration _decoration(bool selected) {
    return BoxDecoration(
      border: Border.all(
        color: selected ? Colors.orange : Colors.grey,
        width: selected ? 3 : 1,
      ),
      borderRadius: BorderRadius.circular(12),
    );
  }
}