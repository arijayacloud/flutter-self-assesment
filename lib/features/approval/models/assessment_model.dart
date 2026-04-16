import 'user_model.dart';
import 'detail_model.dart';

class AssessmentModel {
  final int id;
  final String status;
  final UserModel? user;
  final List<DetailModel> details;

  AssessmentModel({
    required this.id,
    required this.status,
    this.user,
    required this.details,
  });

  factory AssessmentModel.fromJson(Map<String, dynamic> json) {
    return AssessmentModel(
      id: json['id'],
      status: json['status'] ?? '-',
      user: json['user'] != null
          ? UserModel.fromJson(json['user'])
          : null,
      details: (json['details'] as List? ?? [])
          .map((e) => DetailModel.fromJson(e))
          .toList(),
    );
  }
}