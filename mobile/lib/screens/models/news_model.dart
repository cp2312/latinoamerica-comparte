class NewsModel {
  final String id;
  final String title;
  final String country;
  final String content;
  final String status;
  final String image;

  NewsModel({
    required this.id,
    required this.title,
    required this.country,
    required this.content,
    required this.status,
    required this.image,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['_id'] ?? '',
      title: json['titulo'] ?? '',
      country: json['pais'] ?? '',
      content: json['contenido'] ?? '',
      status: json['estado'] ?? '',
      image: json['imagen'] ?? '',
    );
  }
}