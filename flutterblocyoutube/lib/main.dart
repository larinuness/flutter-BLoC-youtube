import 'package:flutter/material.dart';
import 'package:flutterblocyoutube/api.dart';

import 'screens/home.dart';

void main() {
  Api api = Api();
  api.search("eletro");
  runApp(const YoutubeApp());
}

class YoutubeApp extends StatelessWidget {
  const YoutubeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
