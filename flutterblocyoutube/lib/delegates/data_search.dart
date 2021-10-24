import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataSearch extends SearchDelegate<String> {
  //botões que vai ficar aparecendo quando pesquisa
  //lado direito
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          //quando clicar no X apagar tudo
          query = '';
        },
      )
    ];
  }

  //widget que fica no canto esquerdo
  //button de voltar
  //animação quando clica pra voltar
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Future.delayed(Duration.zero).then((_) => close(context, query));
    return Container();
  }

  //função que vai mostrar a liste com sugestões
  @override
  Widget buildSuggestions(BuildContext context) {
    //se não digitar nada, vai aparece só o container vazio
    if (query.isEmpty) {
      return Container();
      //vai aparecer a lista com sugestões
    } else {
      return FutureBuilder<List>(
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index]),
                    leading: const Icon(Icons.play_arrow),
                    onTap: () {
                      //pega o valor que foi clicado
                      close(context, snapshot.data![index]);
                    },
                  );
                },
                itemCount: snapshot.data!.length);
          }
        },
        future: suggestions(query),
      );
    }
  }

  //função pra aparecer as sugestões quando digita
  Future<List> suggestions(String search) async {
    http.Response response = await http.get(Uri.parse(
        "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"));
    if (response.statusCode == 200) {
      //pra cada um dos v vai retornar o 0
      return json.decode(response.body)[1].map((v) {
        return v[0];
      }).toList();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }
}
