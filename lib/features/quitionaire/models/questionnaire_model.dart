class Questionnaire {
  final int id;
  final String question;
  final String category;
  final int weight;

  Questionnaire({
    required this.id,
    required this.question,
    required this.category,
    required this.weight,
  });

  factory Questionnaire.fromJson(Map<String, dynamic> json) {
    return Questionnaire(
      id: json['id'],
      question: json['name'],
      category: json['category'].toString(),
      weight: json['weight'] ?? 1,
    );
  }
}