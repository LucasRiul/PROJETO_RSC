import 'package:flutter/material.dart';

class Categoria {
  final String uid;
  final String nome;
  final String cor;
  final Icon icone;

  Categoria(this.uid, this.nome, this.cor, this.icone);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'nome': nome,
      'cor': cor,
      'icone': icone
    };
  }

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(json['uid'], json['nome'], json['cor'], json['icone']);
  }
}
