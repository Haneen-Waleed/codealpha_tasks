class QuotesModel {
  String? quote;
  String? author;
  String? work;
  List<String>? categories;

  QuotesModel({this.quote, this.author, this.work, this.categories});

  QuotesModel.fromJson(Map<String, dynamic> json) {
    quote = json['quote'];
    author = json['author'];
    work = json['work'];
    categories = json['categories'] != null
        ? List<String>.from(json['categories'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quote'] = quote;
    data['author'] = author;
    data['work'] = work;
    data['categories'] = categories;
    return data;
  }
}