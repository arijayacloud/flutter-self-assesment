class DashboardModel {
  final double totalScore;
  final String status;
  final List<Detail> details;

  DashboardModel({
    required this.totalScore,
    required this.status,
    required this.details,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      // totalScore: (json['total_score'] ?? 0).toDouble(),
      totalScore: double.tryParse(json['total_score'].toString()) ?? 0.0,
      status: json['status'] ?? '',
      details: (json['details'] as List)
          .map((e) => Detail.fromJson(e))
          .toList(),
    );
  }
}

class Detail {
  final String name;
  final int score;
  final double finalScore;

  Detail({
    required this.name,
    required this.score,
    required this.finalScore,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      name: json['name'] ?? '',
      score: json['score'] ?? 0,
      // finalScore: (json['final_score'] ?? 0).toDouble(),
      finalScore: double.tryParse(json['final_score'].toString()) ?? 0.0,
    );
  }
}