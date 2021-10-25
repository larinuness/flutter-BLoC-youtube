import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import '../blocs/favorite_bloc.dart';
import '../models/video.dart';
import 'api.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<FavoriteBloc>();

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Favoritos'),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: StreamBuilder<Map<String, Video>>(
        stream: bloc.outFav,
        //esse initialData garante que o snapshot.data nunca vai ser chamado em nulo
        initialData: const {},
        builder: (context, snapshot) {
          return ListView(
            //pego só os vídeos, não pego a key do map
            children: snapshot.data!.values.map((v) {
              //inkwell para poder tocar nos elementos da lista e ter um efeito visual
              return InkWell(
                //colocar player do youtube aqui
                onTap: () {
                  FlutterYoutube.playYoutubeVideoById(
                      apiKey: API_KEY, videoId: v.id);
                },
                onLongPress: () {
                  //excluo da lista de favoritos
                  bloc.toggleFavorite(v);
                },
                child: Row(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 100,
                      child: Image.network(v.thumb),
                    ),
                    Expanded(
                        child: Text(
                      v.title,
                      style: const TextStyle(color: Colors.white70),
                      maxLines: 2,
                    ))
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
