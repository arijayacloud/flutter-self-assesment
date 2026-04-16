import 'criteria_model.dart';

class DetailModel {
  final int score;
  final CriteriaModel? criteria;

  DetailModel({
    required this.score,
    this.criteria,
  });

  factory DetailModel.fromJson(Map<String, dynamic> json) {
    return DetailModel(
      score: json['score'] ?? 0,
      criteria: json['criteria'] != null
          ? CriteriaModel.fromJson(json['criteria'])
          : null,
    );
  }
}