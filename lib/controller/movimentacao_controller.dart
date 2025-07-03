import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_auth/model/movimentacao.dart';
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

  Future<List<Map<String, dynamic>>> listarComFiltro(
      String mes, String ano) async {
    mes = _converterMes(mes);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('movimentacao')
        .where('uid', isEqualTo: LoginController().idUsuario())
        .where('mes', isEqualTo: mes)
        .where('ano', isEqualTo: ano)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return []; // Retorna uma lista vazia se não houver dados
    } else {
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    }
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

  _converterMes(mes) {
    mes = mes.toString().toLowerCase();
    if (mes == 'janeiro') return '01';
    if (mes == 'fevereiro') return '02';
    if (mes == 'março') return '03';
    if (mes == 'abril') return '04';
    if (mes == 'maio') return '05';
    if (mes == 'junho') return '06';
    if (mes == 'julho') return '07';
    if (mes == 'agosto') return '08';
    if (mes == 'setembro') return '09';
    if (mes == 'outubro') return '10';
    if (mes == 'novembro') return '11';
    if (mes == 'dezembro') return '12';
  }
}
