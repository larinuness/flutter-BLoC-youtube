import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'blocs/favorite_bloc.dart';
import 'blocs/videos_bloc.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //esse provider é a classe que vai passar o bloc em qualquer lugar do código
    return BlocProvider(
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FlutterTube',
        home: Home(),
      ),
      blocs: [Bloc((i) => VideosBloc()), Bloc((i) => FavoriteBloc())],
      dependencies: const [],
    );
  }
}
