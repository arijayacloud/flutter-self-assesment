class CriteriaModel {
  final int id;
  final String name;
  final int weight;

  CriteriaModel({
    required this.id,
    required this.name,
    required this.weight,
  });

  factory CriteriaModel.fromJson(Map<String, dynamic> json) {
    return CriteriaModel(
      id: json['id'],
      name: json['name'] ?? '-',
      weight: json['weight'] ?? 0,
    );
  }
}