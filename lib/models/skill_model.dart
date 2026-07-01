class SkillModel {
  final String id;
  final String name;
  final String category;
  final String level;
  final int proficiency; // 0 - 100

  SkillModel({
    required this.id,
    required this.name,
    required this.category,
    required this.level,
    required this.proficiency,
  }) {
    assert(proficiency >= 0 && proficiency <= 100, 'Proficiency must be between 0 and 100');
  }

  // Get fractional proficiency (0.0 - 1.0) for Flutter progress indicators
  double get fraction => proficiency / 100.0;

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? 'General',
      level: json['level'] ?? 'Intermediate',
      proficiency: (json['proficiency'] ?? 75) as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'level': level,
      'proficiency': proficiency,
    };
  }
}
