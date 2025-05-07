class KukerData {
  String mask;
  String horns;
  String costume;
  String accessory;
  String expression;
  String shoes;

  KukerData({
    required this.mask,
    required this.horns,
    required this.costume,
    required this.accessory,
    required this.expression,
    required this.shoes,
  });

  factory KukerData.defaultKuker() => KukerData(
    mask: 'mask_01',
    horns: 'horns_01',
    costume: 'costume_01',
    accessory: 'none',
    expression: 'neutral',
    shoes: 'none',
  );

  Map<String, String> toMap() => {
    'mask': mask,
    'horns': horns,
    'costume': costume,
    'accessory': accessory,
    'expression': expression,
    'shoes': shoes,
  };

  factory KukerData.fromMap(Map<String, dynamic> map) {
    return KukerData(
      mask: map['mask'] ?? 'mask_01',
      horns: map['horns'] ?? 'horns_01',
      costume: map['costume'] ?? 'costume_01',
      accessory: map['accessory'] ?? 'none',
      expression: map['expression'] ?? 'neutral',
      shoes: map['shoes'] ?? 'none',
    );
  }

  KukerData copyWith({
    String? mask,
    String? horns,
    String? costume,
    String? accessory,
    String? expression,
    String? shoes,
  }) {
    return KukerData(
      mask: mask ?? this.mask,
      horns: horns ?? this.horns,
      costume: costume ?? this.costume,
      accessory: accessory ?? this.accessory,
      expression: expression ?? this.expression,
      shoes: shoes ?? this.shoes,
    );
  }
}