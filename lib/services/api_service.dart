import 'package:flutter_webtoon/models/webtoon_detail_model.dart';
import 'package:flutter_webtoon/models/webtoon_episode_model.dart';
import 'package:flutter_webtoon/models/webtoon_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ApiService {
  static const String baseUrl = "webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  static Future<List<WebtoonModel>> getTodayToons() async {
    List<WebtoonModel> webtoonInstances = [];

    final url = Uri(
      scheme: 'https',
      host: baseUrl,
      path: today,
    );

    var response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> webtoons = convert.jsonDecode(response.body);

      for (var webtoon in webtoons) {
        webtoonInstances.add(WebtoonModel.fromJson(webtoon));
      }
      return webtoonInstances;
    }

    throw Error();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri(
      scheme: 'https',
      host: baseUrl,
      path: id,
    );

    var response = await http.get(url);
    if (response.statusCode == 200) {
      final detail = convert.jsonDecode(response.body);
      WebtoonDetailModel webtoonDetail = WebtoonDetailModel.fromJson(detail);
      return webtoonDetail;
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getToonByIdEpisodes(
      String id) async {
    List<WebtoonEpisodeModel> episodeInstances = [];
    final url = Uri(
      scheme: 'https',
      host: baseUrl,
      path: '$id/episodes',
    );
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> episodes = convert.jsonDecode(response.body);
      for (var episode in episodes) {
        episodeInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodeInstances;
    }
    throw Error();
  }
}
