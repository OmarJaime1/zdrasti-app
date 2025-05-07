class KukerItem {
  final String id;
  final String category;
  final String assetPath;
  final int xpRequired;
  final String rarity;
  final String source;

  KukerItem({
    required this.id,
    required this.category,
    required this.assetPath,
    required this.xpRequired,
    required this.rarity,
    required this.source,
  });

  factory KukerItem.fromMap(Map<String, dynamic> map) {
    return KukerItem(
      id: map['id'],
      category: map['category'],
      assetPath: map['asset_path'],
      xpRequired: map['xp_required'] ?? 0,
      rarity: map['rarity'] ?? 'common',
      source: map['source'] ?? 'base',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'asset_path': assetPath,
      'xp_required': xpRequired,
      'rarity': rarity,
      'source': source,
    };
  }
}
