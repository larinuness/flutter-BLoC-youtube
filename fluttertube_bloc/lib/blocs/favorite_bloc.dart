import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube_bloc/models/video.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteBloc implements BlocBase {
  Map<String, Video> _favorites = {};

//aqui precisávamos usar o broadcast quando era só bloc para ter vários objetos observando o mesmo stream
//quando troco para o behavior eu consigo ver os favoritos marcados quando rebuildo o app
  final _favController = BehaviorSubject<Map<String, Video>>();
  Stream<Map<String, Video>> get outFav => _favController.stream;

  //salvando permanentemente a lista de favoritos
  FavoriteBloc() {
    //prefs é o objeto onde vou gerenciar as minhas preferências
    SharedPreferences.getInstance().then((prefs) {
      //se alguma vez eu já salvei alguma lista de favoritos, vou retornar essa lista de favoritos
      if (prefs.getKeys().contains('favorites')) {
        //salvando os favoritos num formato json, o sharedPreference só permite que salve uma stream
        //nesse caso utilizamos o map para mapear um mapa e não uma lista
        _favorites = json.decode(prefs.getString('favorites')!).map((k, v) {
          return MapEntry(k, Video.fromJson(v));
        }).cast<String, Video>();
        _favController.add(_favorites);
      }
    });
  }

  void toggleFavorite(Video video) {
    //se já tiver na lista eu removo ele
    if (_favorites.containsKey(video.id)) {
      _favorites.remove(video.id);
    } else {
      //aqui se não tiver na lista vai adicionar
      _favorites[video.id] = video;
    }
    _favController.sink.add(_favorites);
    _saveFav();
  }

  void _saveFav() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('favorites', json.encode(_favorites));
    });
  }

  @override
  void addListener(VoidCallback listener) {}

  @override
  void dispose() {
    _favController.close();
  }

  @override
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {}

  @override
  void removeListener(VoidCallback listener) {}
}
