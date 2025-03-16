class MovieModel {
  final String id;
  final String title;
  final String language;
  final int year;

  MovieModel({
    required this.id,
    required this.title,
    required this.language,
    required this.year,
  });

  // Convert a Movie object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'language': language,
      'year': year,
    };
  }

  // Convert a Map object into a Movie object
  factory MovieModel.fromMap(Map<String, dynamic> map) {
    return MovieModel(
      id: map['id'],
      title: map['title'],
      language: map['language'],
      year: map['year'],
    );
  }
}