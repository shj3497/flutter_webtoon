import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webtoon/models/webtoon_episode_model.dart';
import 'package:flutter_webtoon/models/webtoon_model.dart';
import 'package:flutter_webtoon/services/api_service.dart';
import 'package:flutter_webtoon/widgets/webtoon_episode_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/webtoon_detail_model.dart';

class DetailScreen extends StatelessWidget {
  final WebtoonModel webtoon;
  final Future<WebtoonDetailModel> webtoonDetail;
  final Future<List<WebtoonEpisodeModel>> episodes;

  DetailScreen({super.key, required this.webtoon})
      : webtoonDetail = ApiService.getToonById(webtoon.id),
        episodes = ApiService.getToonByIdEpisodes(webtoon.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          webtoon.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        actions: [
          FavoriteButtonWidget(
            webtoonId: webtoon.id,
          )
        ],
      ),
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: webtoon.id,
                    child: Container(
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15,
                            offset: const Offset(10, 10),
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image.network(
                        webtoon.thumb,
                        headers: const {'Referer': 'https://comic.naver.com'},
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: webtoonDetail,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text('...');
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          '${snapshot.data!.genre} / ${snapshot.data!.age}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 50,
              ),
              FutureBuilder(
                future: episodes,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        for (var episode in snapshot.data!)
                          WebtoonEpisodeWidget(
                            episode: episode,
                            webtoonId: webtoon.id,
                          )
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}

class FavoriteButtonWidget extends StatefulWidget {
  final String webtoonId;
  const FavoriteButtonWidget({
    super.key,
    required this.webtoonId,
  });

  @override
  State<FavoriteButtonWidget> createState() => _FavoriteButtonWidgetState();
}

class _FavoriteButtonWidgetState extends State<FavoriteButtonWidget> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    loadFavoriteStatus();
  }

  Future<void> loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool(widget.webtoonId) ?? false;
    });
  }

  Future<void> toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = !isFavorite;
      prefs.setBool(widget.webtoonId, isFavorite);
    });
  }

  Widget favoriteIcon() {
    if (isFavorite) {
      return const Icon(
        Icons.favorite,
      );
    }
    return const Icon(
      Icons.favorite_outline,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: toggleFavorite,
      icon: favoriteIcon(),
      color: Colors.red,
    );
  }
}
