class WebtoonModel {
  final String id;
  final String title;
  final String thumb;

  WebtoonModel.fromJson(Map<String, dynamic> json)
      : thumb = json["thumb"],
        title = json['title'],
        id = json['id'];
}
