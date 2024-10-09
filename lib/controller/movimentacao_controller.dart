import 'dart:js';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/model/movimentacao.dart';
import '../Screens/view/TelaPrincipal/tela_principal.dart';
import '../util.dart';
import 'login_controller.dart';

class MovimentacaoController {
  //
  // ADICIONAR uma nova movimentacao na Coleção
  //
  void adicionar(context, Movimentacao t) {
    FirebaseFirestore.instance
        .collection('movimentacao')
        .add(t.toJson())
        .then(
            (value) => sucesso(context, 'Movimentação adicionada com sucesso'))
        .catchError((e) => erro(context, 'ERRO: ${e.code.toString()}'));
  }

  //
  // LISTAR
  //
  listar() {
    return FirebaseFirestore.instance
        .collection('movimentacao')
        .where('uid', isEqualTo: LoginController().idUsuario())
        .orderBy('data', descending: true);
  }

  //
  // ATUALIZAR
  //
  void atualizar(context, id, Movimentacao t) {
    FirebaseFirestore.instance
        .collection('movimentacao')
        .doc(id)
        .update(t.toJson())
        .then(
            (value) => sucesso(context, 'Movimentação atualizada com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível atualizar a tarefa.'));
  }

  //
  // EXCLUIR
  //
  void excluir(context, id) {
    FirebaseFirestore.instance
        .collection('movimentacao')
        .doc(id)
        .delete()
        .then((value) => sucesso(context, 'Movimentação excluída com sucesso'))
        .catchError((e) => erro(context, 'Não foi possível excluir a tarefa.'));
  }
}
