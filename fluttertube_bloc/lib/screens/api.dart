import 'dart:convert';

import 'package:fluttertube_bloc/models/video.dart';
import 'package:http/http.dart' as http;

// ignore: constant_identifier_names
const API_KEY = "AIzaSyDpOSiYf1pX-DCS8WLTtfXAvGZ9YZ9nqhc";

//"https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"
//"https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken"
//"http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"

class Api {
  String? _search;
  String? _nextToken;

  Future<List<Video>> search(String search) async {
    //além da pesquisa eu armazeno a string dentro de _search para usar no nextPage

    _search = search;
    http.Response response = await http.get(Uri.parse(
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10'));

    return decode(response);
  }

  Future<List<Video>> nextPage() async {
    http.Response response = await http.get(Uri.parse(
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken'));

    return decode(response);
  }

  List<Video> decode(http.Response response) {
    if (response.statusCode == 200) {
      //retorna os dados do json
      var decoded = json.decode(response.body);

      //pega o nextPageToken do json e salva na variável nextToken
      _nextToken = decoded['nextPageToken'];

      List<Video> videos = decoded['items'].map<Video>((map) {
        //pega cada um dos mapas do items do json e tranforma em objeto video
        return Video.fromJson(map);
      }).toList();
      //no final transforma em uma lista de videos

      return videos;
    } else {
      throw Exception('Failed to load videos');
    }
  }
}
