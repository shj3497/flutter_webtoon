import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webtoon/models/webtoon_episode_model.dart';
import 'package:url_launcher/url_launcher.dart';

class WebtoonEpisodeWidget extends StatelessWidget {
  final WebtoonEpisodeModel episode;
  final String webtoonId;

  const WebtoonEpisodeWidget(
      {super.key, required this.episode, required this.webtoonId});

  void onPress() async {
    var url = Uri.parse(
        'https://comic.naver.com/webtoon/detail?titleId=$webtoonId&no=${episode.id}');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: 4,
          right: 8,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Image.network(
                episode.thumb,
                headers: const {'Referer': 'https://comic.naver.com'},
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.title,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 12,
                        color: Colors.black26,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        episode.rating,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black26),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        episode.date,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black26),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
