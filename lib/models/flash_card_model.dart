class Flashcard {
  String question;
  String answer;
  String hint;
  String folderId;
  Flashcard({required this.question,required this.answer,required this.hint,required this.folderId});

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      question: map['Question']?.toString() ?? '',
      answer: map['Answer']?.toString() ?? '',
      hint: map['Hint']?.toString() ?? '',
      folderId: map['FolderId']?.toString() ?? '',
    );
  }
}
