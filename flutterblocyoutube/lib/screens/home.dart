import 'package:flutter/material.dart';
import 'package:flutterblocyoutube/delegates/data_search.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 70,
          child: Image.asset("images/youtubelogo.png"),
        ),
        //pra não fica com sombra embaixo
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.black87,
        actions: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              '0',
              style: TextStyle(fontSize: 16.5),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.star,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () async {
              //pega a palavra que foi pesquisada
              String? result =
                  await showSearch(context: context, delegate: DataSearch());
              print(result);
            },
            icon: const Icon(
              Icons.search,
              size: 30,
            ),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
