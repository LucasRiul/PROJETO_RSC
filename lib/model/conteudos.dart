class Conteudos {
  int id;
  String foto;
  String descricao;
  String tema;

  Conteudos(this.id, this.foto, this.descricao, this.tema);

  factory Conteudos.fromJson(Map<String, dynamic> j) {
    return Conteudos(j['id'], j['foto'], j['descricao'], j['tema']);
  }
}
