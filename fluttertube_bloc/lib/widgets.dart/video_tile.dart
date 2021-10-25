import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import '../blocs/favorite_bloc.dart';

import '../models/video.dart';
import '../screens/api.dart';

// ignore: must_be_immutable
class VideoTile extends StatelessWidget {
  Video video;

  VideoTile({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<FavoriteBloc>();
    Map<String, Video> map = {};

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //com aspect ratio eu delimito a proporção da imagem
            AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: Image.network(
                video.thumb,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: GestureDetector(
                          onTap: FlutterYoutube.playYoutubeVideoById(apiKey: API_KEY, videoId: video.id),
                          child: Text(video.title,style: const TextStyle(
                              color: Colors.white, fontSize: 16)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(video.channel,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14)),
                      ),
                    ],
                  ),
                ),
                StreamBuilder<Map<String, Video>>(
                  stream: bloc.outFav,
                  //initialData vazio porque ele só vai ter dados depois do sink.add
                  initialData: map,
                  builder:
                      //esse snapshot vai conter toda a lista de favoritos
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      return IconButton(
                        icon: Icon(snapshot.data.containsKey(video.id)
                            ? Icons.star
                            : Icons.star_border),
                        color: Colors.white,
                        iconSize: 30,
                        onPressed: () {
                          bloc.toggleFavorite(video);
                        },
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                )
              ],
            )
          ],
        ),
      );
    
  }
}
