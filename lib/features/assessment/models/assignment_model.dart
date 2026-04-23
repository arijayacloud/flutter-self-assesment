class Assignment {
  final String date;
  final int totalQuestion;
  final String status;

  Assignment({
    required this.date,
    required this.totalQuestion,
    required this.status,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      date: json['date'],
      totalQuestion: json['total_question'],
      status: json['status'],
    );
  }
}