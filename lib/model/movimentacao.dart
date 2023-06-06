class Movimentacao {
  final String uid;
  final String tipoMovimentacao;
  final String valor;
  final String data;

  Movimentacao(this.uid, this.tipoMovimentacao, this.valor, this.data);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'tipoMovimentacao': tipoMovimentacao,
      'valor': valor,
      'data': data,
    };
  }

  factory Movimentacao.fromJson(Map<String, dynamic> json) {
    return Movimentacao(
        json['uid'], json['tipoMovimentacao'], json['valor'], json['data']);
  }
}
