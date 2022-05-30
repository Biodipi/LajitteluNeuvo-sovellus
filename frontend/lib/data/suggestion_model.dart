class SuggestionModel {
  final String title;
  final String href;

  const SuggestionModel(
    this.title,
    this.href,
  );

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      json['title'],
      json['href'],
    );
  }
}
