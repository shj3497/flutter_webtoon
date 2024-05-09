class WebtoonEpisodeModel {
  final String thumb;
  final String id;
  final String title;
  final String rating;
  final String date;

  WebtoonEpisodeModel.fromJson(Map<String, dynamic> json)
      : thumb = json['thumb'],
        id = json['id'],
        title = json['title'],
        rating = json['rating'],
        date = json['date'];
}
