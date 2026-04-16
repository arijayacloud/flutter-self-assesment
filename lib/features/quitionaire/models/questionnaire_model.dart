class QuestionnaireModel {
  final int id;
  final String name;
  final String type;
  final int weight;

  QuestionnaireModel({
    required this.id,
    required this.name,
    required this.type,
    required this.weight,
  });

  factory QuestionnaireModel.fromJson(Map<String, dynamic> json) {
    return QuestionnaireModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      weight: json['weight'],
    );
  }
}