import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/controller/movimentacao_controller.dart';

import '../../../../controller/login_controller.dart';
import '../../../../model/movimentacao.dart';

class ListaMovimentacoes extends StatefulWidget {
  const ListaMovimentacoes({super.key});

  @override
  State<ListaMovimentacoes> createState() => _ListaMovimentacoesState();
}

class _ListaMovimentacoesState extends State<ListaMovimentacoes> {
  @override
  var txtTipoMovimentacao = TextEditingController();
  var valor = TextEditingController();
  var data = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: MovimentacaoController().listar().snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                  child: Text('Não foi possível conectar.'),
                );
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                final dados = snapshot.requireData;
                if (dados.size > 0) {
                  return ListView.builder(
                    itemCount: dados.size,
                    itemBuilder: (context, index) {
                      String id = dados.docs[index].id;
                      dynamic item = dados.docs[index].data();
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.description),
                          title: Text(item['titulo']),
                          subtitle: Text(item['descricao']),
                          onTap: () {
                            txtTipoMovimentacao.text = item['tipoMovimentacao'];
                            valor.text = item['valor'];
                            data.text = item['data'];
                            adicionarMovimentacao(context, docId: id);
                          },
                          onLongPress: () {
                            MovimentacaoController().excluir(context, id);
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text('Nenhuma tarefa encontrada.'),
                  );
                }
            }
          },
        ),
      ),
    );
  }

  void adicionarMovimentacao(context, {docId}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: Text("Adicionar Movimentação"),
          content: SizedBox(
            height: 250,
            width: 300,
            child: Column(
              children: [
                TextField(
                  controller: txtTipoMovimentacao,
                  decoration: InputDecoration(
                    labelText: 'Tipo Movimentação',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 10)),
                TextField(
                  controller: valor,
                  decoration: InputDecoration(
                    labelText: 'Valor(R\$)',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 10)),
                TextField(
                  controller: data,
                  decoration: InputDecoration(
                    labelText: 'Data',
                    prefixIcon: Icon(Icons.date_range),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          actions: [
            TextButton(
              child: Text("fechar"),
              onPressed: () {
                txtTipoMovimentacao.clear();
                valor.clear();
                data.clear();
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("salvar"),
              onPressed: () {
                var t = Movimentacao(LoginController().idUsuario(),
                    txtTipoMovimentacao.text, valor.text, data.text);
                txtTipoMovimentacao.clear();
                valor.clear();
                data.clear();
                if (docId == null) {
                  MovimentacaoController().adicionar(context, t);
                } else {
                  MovimentacaoController().atualizar(context, docId, t);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
