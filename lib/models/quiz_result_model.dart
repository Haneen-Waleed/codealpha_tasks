class QuizResultModel {
  final int score;
  final int totalQuestions;
  final String folderId;
  final DateTime date;

  QuizResultModel({
    required this.score,
    required this.totalQuestions,
    required this.folderId,
    required this.date,
  });

  factory QuizResultModel.fromMap(Map<String, dynamic> map) {
    return QuizResultModel(
      score: map['score'] ?? 0,
      totalQuestions: map['totalQuestions'] ?? 0,
      folderId: map['folderId'] ?? '',
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
    );
  }

  bool get isPerfect => score == totalQuestions && totalQuestions > 0;
  double get percentage => totalQuestions == 0 ? 0 : (score / totalQuestions) * 100;
}