import 'dart:convert';

import 'package:flutterblocyoutube/models/video.dart';
import 'package:http/http.dart' as http;

const apiKey = "AIzaSyBnrzhVfM85mZMhTh-9QtV2p8vBEQp2rWI";

class Api {
  search(String search) async {
    http.Response response = await http.get(Uri.parse(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$apiKey&maxResults=10"));

    decode(response);
  }

  List<Video> decode(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);

      //items porque todos os parametros estão dentro dele
      //pega os maps e transforma em objeto video
      List<Video> videos = decoded['items'].map<Video>((map) {
        return Video.fromJson(map);
      }).toList();
      return videos;
    } else {
      throw Exception("Failed to load videos");
    }
  }
}
