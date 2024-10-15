import 'dart:js_interop';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/controller/movimentacao_controller.dart';
import 'package:flutter_auth/model/movimentacao.dart';
import '../../../../constants.dart';
import '../../../../controller/login_controller.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:easy_mask/easy_mask.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Movimentacoes extends StatefulWidget {
  const Movimentacoes({super.key});

  @override
  State<Movimentacoes> createState() => _MovimentacoesState();
}

class _MovimentacoesState extends State<Movimentacoes> {
  var txtTitulo = TextEditingController();
  var txtDescricao = TextEditingController();

  String txtTipoMovimentacao = '';
  var valor = TextEditingController();
  var data = TextEditingController();
  var descricao = TextEditingController();

  // Lista de categorias
  List<dynamic> categorias = [];
  String? categoriaSelecionada;

  @override
  void initState() {
    super.initState();
    carregarCategorias(); // Carregar categorias uma vez no início
  }

  // Carregar dados do JSON
  carregarCategorias() async {
    try {
      final String response =
          await rootBundle.loadString('lib/data/categorias.json');
      final data = json.decode(response);
      setState(() {
        categorias = data;
      });
    } catch (e) {
      print("Erro ao carregar categorias: $e"); // Exibe o erro no console
    }
  }

  IconData _mapIcon(String iconName) {
    // Mapeamento dos nomes dos ícones para os ícones reais do Flutter
    switch (iconName) {
      case "house_outlined":
        return Icons.house_outlined;
      case "account_balance_wallet_outlined":
        return Icons.account_balance_wallet_outlined;
      case "directions_car_outlined":
        return Icons.directions_car_outlined;
      case "restaurant_outlined":
        return Icons.restaurant_outlined;
      case "shopping_cart_outlined":
        return Icons.shopping_cart_outlined;
      case "wallet_giftcard_outlined":
        return Icons.wallet_giftcard_outlined;
      case "currency_exchange_outlined":
        return Icons.currency_exchange_outlined;
      case "book_outlined":
        return Icons.book_outlined;
      case "healing_outlined":
        return Icons.healing_outlined;
      case "business_outlined":
        return Icons.business_outlined;
      case "space_dashboard_outlined":
        return Icons.space_dashboard_outlined;
      default:
        return Icons.category_outlined; // Ícone padrão
    }
  }

  void adicionarMovimentacao(context, {docId, dynamic movimentacao}) {
    if (movimentacao != null) {
      // Se for edição, preencher os campos com os dados existentes
      txtTipoMovimentacao = movimentacao['tipo'];
      valor.text = movimentacao['valor'].toString();
      data.text = movimentacao['data'].toString();
      descricao.text = movimentacao['descricao'].toString();
      categoriaSelecionada = movimentacao['categoria'].toString();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: carregarCategorias(), // Carrega as categorias
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return AlertDialog(
                title: Text("Erro ao carregar categorias"),
                content: Text("Ocorreu um erro ao carregar as categorias."),
              );
            } else {
              return AlertDialog(
                title: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child:
                          docId == null ? Text("Adicionar") : Text("Alterar"),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          txtTipoMovimentacao = '';
                          valor.clear();
                          data.clear();
                          descricao.clear();
                          categoriaSelecionada = categorias.isNotEmpty
                              ? categorias[0]['Nome']
                              : ''; // Reseta a categoria;
                          Navigator.of(context).pop(); // Fecha o diálogo
                        },
                      ),
                    ),
                  ],
                ),
                content: SizedBox(
                  height: 300,
                  width: 350,
                  child: Column(
                    children: [
                      CustomRadioButton(
                        elevation: 2,
                        enableShape: true,
                        shapeRadius: 20,
                        absoluteZeroSpacing: true,
                        defaultSelected: txtTipoMovimentacao.isNotEmpty
                            ? txtTipoMovimentacao
                            : null,
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        padding: 10,
                        spacing: 30,
                        unSelectedColor: Colors.white,
                        buttonLables: [
                          'Gasto',
                          'Ganho',
                        ],
                        buttonValues: [
                          "GASTO",
                          "GANHO",
                        ],
                        buttonTextStyle: ButtonTextStyle(
                            selectedColor: Colors.white,
                            unSelectedColor: Colors.black,
                            textStyle: TextStyle(fontSize: 16)),
                        radioButtonValue: (value) {
                          txtTipoMovimentacao = value.toString();
                        },
                        selectedColor: kPrimaryColor,
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 10)),
                      TextField(
                        controller: valor,
                        inputFormatters: [
                          TextInputMask(
                              mask: 'R!\$! !9+,99',
                              placeholder: '0',
                              maxPlaceHolders: 3,
                              reverse: true)
                        ],
                        decoration: InputDecoration(
                          labelText: 'Valor(R\$)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 10)),
                      TextField(
                        controller: data,
                        inputFormatters: [
                          TextInputMask(mask: '99/99/9999', reverse: false)
                        ],
                        decoration: InputDecoration(
                          labelText: 'Data',
                          hintText: 'Date',
                          prefixIcon: Icon(Icons.date_range),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 10)),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        alignment: Alignment.center,
                        decoration: InputDecoration(
                          labelText: 'Categoria',
                          border: OutlineInputBorder(),
                        ),
                        value: categoriaSelecionada,
                        items: categorias
                            .map<DropdownMenuItem<String>>((categoria) {
                          return DropdownMenuItem<String>(
                            value: categoria['Nome'],
                            child: Row(
                              children: [
                                Icon(
                                  _mapIcon(categoria['Icone']),
                                  color: Color(int.parse(
                                      '0xff${categoria['Cor'].substring(1)}')),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  categoria['Nome'],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            categoriaSelecionada = value;
                          });
                        },
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 10)),
                      TextField(
                        controller: descricao,
                        decoration: InputDecoration(
                          labelText: 'Descrição',
                          prefixIcon: Icon(Icons.edit),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                actionsPadding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                actions: [
                  ElevatedButton(
                    child: Text(
                      "salvar",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      var dataSplit = data.text.split('/');
                      var mes = dataSplit[1];
                      var ano = dataSplit[2];
                      var t = Movimentacao(
                        LoginController().idUsuario(),
                        txtTipoMovimentacao,
                        valor.text.split(' ')[1],
                        data.text,
                        mes,
                        ano,
                        descricao.text,
                        categoriaSelecionada.toString(),
                      );
                      txtTipoMovimentacao = '';
                      valor.clear();
                      data.clear();
                      descricao.clear();
                      categoriaSelecionada = categorias.isNotEmpty
                          ? categorias[0]['Nome']
                          : ''; // Reseta a categoria

                      if (docId == null) {
                        MovimentacaoController().adicionar(context, t);
                      } else {
                        MovimentacaoController().atualizar(context, docId, t);
                      }
                      Navigator.of(context).pop(); // Fecha o diálogo
                    },
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  void confirmarExclusao(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Confirmar exclusão"),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop(); // Fecha o diálogo
                  },
                ),
              ),
            ],
          ),
          content: Text("Tem certeza que deseja excluir esta movimentação?"),
          actions: [
            ElevatedButton(
              child: Text(
                "Excluir",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Cor do botão de exclusão
              ),
              onPressed: () {
                // Função para excluir a movimentação
                MovimentacaoController().excluir(context, docId);
                Navigator.of(context).pop(); // Fecha o diálogo após a exclusão
              },
            ),
          ],
        );
      },
    );
  }

  @override
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
                          leading: item['tipo'] == "GASTO"
                              ? Icon(Icons.keyboard_double_arrow_down,
                                  color: Colors.red)
                              : Icon(Icons.keyboard_double_arrow_up,
                                  color: Colors.green),
                          title: Text(
                              'R\$' +
                                  item['valor'].toString() +
                                  ' - ' +
                                  item['categoria'],
                              overflow: TextOverflow.ellipsis),
                          subtitle: Text(
                            item['descricao'],
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete,
                                color: Color.fromARGB(255, 247, 99, 89)),
                            onPressed: () {
                              confirmarExclusao(context,
                                  id); // Função para confirmar a exclusão
                            },
                          ),
                          onTap: () {
                            txtTitulo.text = item['categoria'];
                            txtDescricao.text = item['descricao'];
                            adicionarMovimentacao(context,
                                docId: id, movimentacao: item);
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
                    child: Text(
                        'Você ainda não cadastrou nenhuma movimentação.',
                        style: TextStyle(color: kPrimaryColor)),
                  );
                }
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          adicionarMovimentacao(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: kPrimaryColor,
      ),
    );
  }
}
