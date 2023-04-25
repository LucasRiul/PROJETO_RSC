class Conteudos {
  int id;
  String foto;
  String descricao;
  String tema;
  String fotoDescricao;
  String link;

  Conteudos(this.id, this.foto, this.fotoDescricao, this.descricao, this.tema,
      this.link);

  factory Conteudos.fromJson(Map<String, dynamic> j) {
    return Conteudos(j['id'], j['foto'], j['fotoDescricao'], j['descricao'],
        j['tema'], j['link']);
  }
}
