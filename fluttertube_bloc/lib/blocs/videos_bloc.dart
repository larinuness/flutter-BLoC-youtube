import 'dart:async';
import 'dart:ui';

import 'package:bloc_pattern/bloc_pattern.dart';

import '../models/video.dart';
import '../screens/api.dart';

class VideosBloc implements BlocBase {
  //acesso a api
  Api? api;

  //dados da lista de vídeos
  late List<Video> videos;

  final StreamController<List<Video>> _videoController =
      StreamController<List<Video>>();
  //dá acesso ao _videosController de fora do bloc
  Stream get outVideos => _videoController.stream;

  //para colocar dados no streamController uso o inSearch.add, sink faz a inclusão do dado
  final StreamController<String> _searchController = StreamController<String>();
  Sink get inSearch => _searchController.sink;

  VideosBloc() {
    api = Api();

    //pegar o dado do searchController e enviar para a api
    _searchController.stream.listen(_search);
  }

  //ver se tem um jeito melhor de arurmar isso, mas ele não aceita que o search seja do tipo string
  void _search(dynamic search) async {
    if (search != null) {
      //envio uma lista vazia para refazer a tela caso no meio da tela de vídeos pesquisados eu tente fazer outra pesquisa
      _videoController.sink.add([]);
      videos = await api!.search(search);
    } else {
      videos += await api!.nextPage();
    }

    _videoController.sink.add(videos);
  }

  @override
  void addListener(VoidCallback listener) {}

  @override
  void dispose() {
    _videoController.close();
    _searchController.close();
  }

  @override
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {}

  @override
  void removeListener(VoidCallback listener) {}
}
