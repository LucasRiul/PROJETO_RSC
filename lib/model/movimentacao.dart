class Movimentacao {
  final String uid;
  final String tipo;
  final String valor;
  final String data;
  final String mes;
  final String ano;
  final String descricao;
  final String categoria;

  Movimentacao(this.uid, this.tipo, this.valor, this.data, this.mes, this.ano,
      this.descricao, this.categoria);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'tipo': tipo,
      'valor': valor,
      'data': data,
      'mes': mes,
      'ano': ano,
      'descricao': descricao,
      'categoria': categoria
    };
  }

  factory Movimentacao.fromJson(Map<String, dynamic> json) {
    return Movimentacao(json['uid'], json['tipo'], json['valor'], json['data'],
        json['mes'], json['ano'], json['descricao'], json['categoria']);
  }
}
