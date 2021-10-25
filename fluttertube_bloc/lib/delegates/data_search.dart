import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//SearchDelegate do tipo string que é o que vamos pesquisar
class DataSearch extends SearchDelegate<String> {
  //botão da direita que aparece durante a pesquisa
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          //query seria a string que digitamos para busca
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  //botão da esquerda que aparece durante a pesquisa
  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  //aqui foi feito algo diferente porque usar só o close seria tentar redesenhar a tela quando isso já tá sendo feito pela função build em si
  //adio a função close para quando o build terminar de desenhar o widget
  @override
  Widget buildResults(BuildContext context) {
    Future.delayed(Duration.zero).then((_) => close(context, query));

    return Container();
  }

  //vai ser carregado toda vez que o usuário digitar algo no search
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
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
                    //quando o usuário clicar numa sugestão o close vai tentar redesenhar a tela e retornar para a tela inicial mostrando todos os vídeos
                    close(context, snapshot.data![index]);
                  },
                );
              },
              itemCount: snapshot.data!.length,
            );
          }
        },
        future: suggestions(query),
      );
    }
  }

  Future<List> suggestions(String search) async {
    //de onde vai vir as sugestões
    http.Response response = await http.get(Uri.parse(
        'http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json'));

    if (response.statusCode == 200) {
      //mapeia os valores do json e retorna só a posição 0 de cada item
      return json.decode(response.body)[1].map((v) {
        return v[0];
      }).toList();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }
}
