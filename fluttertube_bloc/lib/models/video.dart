class Video {
  final String id;
  final String title;
  final String thumb;
  final String channel;

  Video({
    required this.id,
    required this.title,
    required this.thumb,
    required this.channel,
  });

  //o factory vai pegar o json e retornar um objeto que contém os dados do json
  factory Video.fromJson(Map<String, dynamic> json) {
    //verificação do formato, se é o formato da google ou o nosso (FromJson / toJson)
    //quando passar um json para o factory ele vai retornar um objeto video com esses parâmetros

    if (json.containsKey('id')) {
      return Video(
        id: json['id']['videoId'],
        title: json['snippet']['title'],
        thumb: json['snippet']['thumbnails']['high']['url'],
        channel: json['snippet']['channelTitle'],
      );
    } else {
      return Video(
        id: json['videoId'],
        title: json['title'],
        thumb: json['thumb'],
        channel: json['channel'],
      );
    }
  }

  //salva num formato diferente que vem da google
  Map<String, dynamic> toJson() {
    return {'videoId': id, 'title': title, 'thumb': thumb, 'channel': channel};
  }
}
