enum CategoryType { income, expense, transfer }

class Category {
  final int? id;
  final String name;
  final int iconCode; // Store IconData.codePoint
  final String? fontFamily;
  final String? fontPackage;
  final int colorValue; // Store Color.value
  final CategoryType type;
  final bool isCustom; // To distinguish between default and user-added

  Category({
    this.id,
    required this.name,
    required this.iconCode,
    this.fontFamily,
    this.fontPackage,
    required this.colorValue,
    required this.type,
    this.isCustom = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconCode': iconCode,
      'fontFamily': fontFamily,
      'fontPackage': fontPackage,
      'colorValue': colorValue,
      'type': type.index, // Store as int
      'isCustom': isCustom ? 1 : 0,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      iconCode: map['iconCode'],
      fontFamily: map['fontFamily'],
      fontPackage: map['fontPackage'],
      colorValue: map['colorValue'],
      type: CategoryType.values[map['type']],
      isCustom: map['isCustom'] == 1,
    );
  }
}
