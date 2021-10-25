import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube_bloc/blocs/favorite_bloc.dart';
import 'package:fluttertube_bloc/blocs/videos_bloc.dart';
import 'package:fluttertube_bloc/delegates/data_search.dart';
import 'package:fluttertube_bloc/models/video.dart';
import 'package:fluttertube_bloc/screens/favorites_screen.dart';
import 'package:fluttertube_bloc/widgets.dart/video_tile.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<VideosBloc>();
    final blocFav = BlocProvider.getBloc<FavoriteBloc>();
    Map<String, Video> map = {};

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: SizedBox(
          height: 25,
          child: Image.asset('images/logo_youtube.png'),
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: [
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              initialData: map,
              builder: (context, snapshot) {
                return Text(
                  //se o snapshot tiver dados retorna o length, se não retorna um texto vazio
                  '${snapshot.data?.length ?? ''}',
                );
                //erro no widget de texto estourando um overflow quando rebuilda a tela
              },
              stream: blocFav.outFav,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FavoritesScreen()));
            },
            icon: const Icon(Icons.star),
          ),
          IconButton(
            onPressed: () async {
              //aqui eu pego o que digito no search do DataSearch que vem pela função close do buildResults
              String? result =
                  await showSearch(context: context, delegate: DataSearch());

              if (result != null) {
                bloc.inSearch.add(result);
              }
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      //quando abrimos o app o stremBuilder não vai receber nenhum dado, vai inicar os dados como sendo vazio, sem vídeos para mostrar
      body: StreamBuilder(
        initialData: const [],
        //sempre que tiver uma alteração na stream outVideos ele vai refazer a tela já que usamos um StreamBuilder
        stream: bloc.outVideos,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                //enquanto estiver nos itens normais (.length) ele vai só carregar os vídeos
                if (index < snapshot.data.length) {
                  return VideoTile(
                    video: snapshot.data[index],
                  );
                  //a listView builder vai acrescentar 1 na quantidade de dados que era vazia, mas sem essa validação do else if vai estourar erro porque não foi realizada nenhuma pesquisa ainda
                } else if (index > 1) {
                  //não quero pesquisar nada, quero só ir até a próxima página
                  bloc.inSearch.add(null);
                  //quando chega no último item ele vai sinalizar o bloc e solicitar o carregamento de mais 10 itens mostrando a barra de progresso enquanto carrega
                  return Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  );
                } else {
                  return Container();
                }
              },
              //passo um item a mais do que realmente existe para usar na lógica de carregamento dos próximos
              itemCount: snapshot.data.length + 1,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
