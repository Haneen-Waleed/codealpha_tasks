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
    categories = json['categories'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quote'] = this.quote;
    data['author'] = this.author;
    data['work'] = this.work;
    data['categories'] = this.categories;
    return data;
  }
}
