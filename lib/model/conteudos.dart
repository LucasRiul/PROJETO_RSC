class Conteudos {
  final int id;
  final String foto;
  final String fotoDescricao;
  final String descricao;
  final String tema;
  final String link;
  final String videoLink;
  final String videoDescricao;

  Conteudos(this.id, this.tema, this.link, this.descricao, this.foto,
      this.fotoDescricao, this.videoLink, this.videoDescricao);

  factory Conteudos.fromJson(Map<String, dynamic> j) {
    return Conteudos(j['id'], j['tema'], j['link'], j['descricao'], j['foto'],
        j['fotoDescricao'], j['videoLink'], j['videoDescricao']);
  }
}
